//
//  DownloadAPITests.swift
//  
//
//  Created by joker on 2024/1/14.
//

import XCTest
import DownloadAPI

final class DownloadAPITests: XCTestCase {

    let client = DownloadAPI()

    func testAllProjects() async throws {
        let projects = try await client.allProjects()
        XCTAssertNotNil(projects)

        if let projects = projects {
            let allProjects = DownloadAPI.Project.allCases
            XCTAssertTrue(projects == allProjects)
        }
    }

    func testPaperLatestBuild() async throws {
        let latestVersion = try await client.latestVersion(project: .paper)
        XCTAssertNotNil(latestVersion)
        if let latestVersion {
            let latestBuild = try await client.latestBuild(project: .paper, version: latestVersion)
            XCTAssertNotNil(latestBuild)
        }
    }
}
 
