//
//  PaperMCAPITests.swift
//
//
//  Created by joker on 2024/1/14.
//

import Testing
import PaperMCAPI

final class PaperMCAPITests {
    
    let client = PaperMCAPI()
    
    @Test
    func allProjects() async throws {
        let projects = try #require(await client.allProjects())
        let allProjects = PaperMCAPI.Project.allCases
        #expect(projects == allProjects)
    }
    
    @Test
    func paperLatestBuild() async throws {
        let latestVersion = try #require(await client.latestVersion(project: .paper))
        let latestBuild = try await client.latestBuild(project: .paper, version: latestVersion)
        #expect(latestBuild != nil)
    }
    
    @Test
    func latestBuildAppAndDownload() async throws {
        let project = PaperMCAPI.Project.paper
        let projectVersion = "1.21.3"
        let response = try #require(await client.latestBuildApplication(project: project, version: projectVersion))
        #expect(response.name == "\(project.name)-\(projectVersion)-\(response.build).jar")
        
        let (httpBody, totalBytes) = try #require(await client.downloadLatestBuild(project: project, version: projectVersion, build: response.build, name: response.name))
        
        var bytesCount = 0
        for try await chunk in httpBody {
            bytesCount += chunk.count
            print("\(Int(Double(bytesCount) / Double(totalBytes) * 100))%")
        }
        #expect(bytesCount == totalBytes)
    }
}
