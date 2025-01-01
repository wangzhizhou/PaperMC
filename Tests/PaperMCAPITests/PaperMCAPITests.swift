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
        let projects = try #require(try await client.allProjects())
        let allProjects = PaperMCAPI.Project.allCases
        #expect(projects == allProjects)
    }
    
    @Test
    func paperLatestBuild() async throws {
        let latestVersion = try #require(try await client.latestVersion(project: .paper))
        let latestBuild = try await client.latestBuild(project: .paper, version: latestVersion)
        #expect(latestBuild != nil)
    }
}

