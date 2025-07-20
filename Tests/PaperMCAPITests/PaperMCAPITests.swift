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
        let sorthandler: (PaperMCAPI.Project, PaperMCAPI.Project) -> Bool = { p1, p2 in
            p1.name < p2.name
        }
        let projects = try #require(await client.allProjects()).sorted(by: sorthandler)
        let allProjects = PaperMCAPI.Project.allCases.sorted(by: sorthandler)
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
        let projectVersion = "1.21.8"
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
