//
//  DownloadAPI.swift
//
//
//  Created by joker on 2024/1/14.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import Common

public struct DownloadAPIClient: Sendable {
    
    private let client = Client(
        serverURL: try! Servers.Server1.url(),
        configuration: .init(dateTranscoder: Common.ISO8601DateTranscoder()),
        transport: URLSessionTransport()
    )
    
    public init() {}
}

public extension DownloadAPIClient {
    
    enum Project: String, CaseIterable {
        case paper
        case travertine
        case waterfall
        case velocity
        case folia
        
        public var name: String { self.rawValue }
    }
    
    func allProjects() async throws -> [Project]? {
        let response = try await client.getProjects()
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let jsonObj):
                return jsonObj.projects?
                    .compactMap { $0.project?.id }
                    .compactMap { Project(rawValue: $0) }
            }
        default:
            return nil
        }
    }
    
    func latestVersion(project: Project) async throws -> String? {
        let response = try await client.getVersions(path: .init(project: project.name))
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let jsonObj):
                let latestVersion = jsonObj.versions?.first
                return latestVersion?.version?.id
            }
        default:
            return nil
        }
    }
    
    func latestBuild(project: Project, version: String) async throws -> Int32? {
        
        let response = try await client.getLatestBuild(.init(path: .init(project: project.name, version: version)))
        
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let jsonObj):
                let latestBuild = jsonObj.id
                return latestBuild
            }
        default:
            break
        }
        return nil
    }
    
    func latestBuildApplication(project: Project, version: String) async throws -> (build: Int32, name: String, sha256: String, downloadUrl: String)? {
        guard let latestBuild = try await latestBuild(project: project, version: version)
        else {
            return nil
        }
        
        let response = try await client.getBuild(.init(path: .init(project: project.name, version: version, build: latestBuild)))
        
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let body):
                guard let downloadInfo = body.downloads?.additionalProperties["server:default"],
                      let name = downloadInfo.name,
                      let sha256 = downloadInfo.checksums?.sha256,
                      let downloadUrl = downloadInfo.url
                else {
                    return nil
                }
                return (latestBuild, name, sha256, downloadUrl)
            }
        default:
            return nil
        }
    }
    
    //    func downloadLatestBuild(
    //        project: Project,
    //        version: String,
    //        build: Int32,
    //        name: String
    //    ) async throws -> (bytes: HTTPBody, totalBytes: Int64)? {
    //
    //        let response = try await client.download(
    //            .init(path: .init(
    //                project: project.name,
    //                version: version,
    //                build: build,
    //                download: name)
    //            )
    //        )
    //
    //        switch response {
    //        case .ok(let output):
    //            switch output.body {
    //            case .json(let jsonObj):
    //                print(jsonObj)
    //            case .application_java_hyphen_archive(let jar):
    //                switch jar.length {
    //                case .known(let total):
    //                    return (jar, total)
    //                case .unknown:
    //                    return nil
    //                }
    //            }
    //        default:
    //            break
    //        }
    //        return nil
    //    }
}
