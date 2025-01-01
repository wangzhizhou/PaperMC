//
//  HangarAPIClient.swift
//
//
//  Created by joker on 2023/6/20.
//
import Common
import OpenAPIRuntime
import OpenAPIURLSession

/// https://hangar.papermc.io/api-docs#/
public struct HangarAPIClient {

    public init() {}

    private let client = Client(
        serverURL: try! Servers.Server1.url(),
        configuration: .init(dateTranscoder: Common.ISO8601DateTranscoder()),
        transport: URLSessionTransport())

    /// 调API前的授权接口
    /// - Parameter apiKey: https://hangar.papermc.io/ 平台帐号申请的apiKey
    /// - Returns: json web token
    public func authenticate(with apiKey: String) async throws -> String? {
        let response = try await client.authenticate(query: .init(apiKey: apiKey))
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let apiSession):
                return apiSession.token
            }
        default:
            return nil
        }
    }
    
    public func versions(for pluginName: String) async throws -> [PluginVersion]? {
        let response = try await client.listVersions(path: .init(slug: pluginName), query: .init(pagination: .init()))
        return try response.ok.body.json.result
    }
    
    public func version(for pluginName: String, versionName: String) async throws -> PluginVersion? {
        let response = try await client.showVersion(path: .init(slug: pluginName, name: versionName))
        return try response.ok.body.json
    }

    public func latestReleaseVersion(for pluginName: String) async throws -> String? {
        let response = try await client.latestReleaseVersion(.init(path: .init(slug: pluginName), headers: .init(accept: [.init(contentType: .plainText)])))
        guard case let .ok(output) = response,
              case let OpenAPIRuntime.HTTPBody.Length.known(bytes) = try output.body.plainText.length
        else {
            return nil
        }
        return try await String(collecting: try output.body.plainText, upTo: Int(bytes))
    }
    
    public func downloadPlugin(name: String, version: String, platform: PluginPlatform) async throws -> PluginJavaArchive {
        let response = try await client.downloadVersion(path: .init(slug: name, name: version, platform: platform))
        return try response.ok.body.application_java_hyphen_archive
    }
}
