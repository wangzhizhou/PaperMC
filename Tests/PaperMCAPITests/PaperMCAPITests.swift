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
        let projects = try await client.allProjects()
        try #require(projects != nil)
        
        if let projects = projects {
            let allProjects = PaperMCAPI.Project.allCases
            #expect(projects == allProjects)
        }
    }
    
    @Test
    func paperLatestBuild() async throws {
        let latestVersion = try await client.latestVersion(project: .paper)
        try #require(latestVersion != nil)
        if let latestVersion {
            let latestBuild = try await client.latestBuild(project: .paper, version: latestVersion)
            #expect(latestBuild != nil)
        }
    }
}

