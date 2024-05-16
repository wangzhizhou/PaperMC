//
//  HangarAPITests.swift
//
//
//  Created by joker on 2023/6/20.
//

import XCTest
import HangarAPI
import Foundation

final class HangarAPITests: XCTestCase {

    let client = HangarAPIClient()

    func testAuth() async throws {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
        let token = try await client.authenticate(with: apiKey)
        if let token {
            print(token)
        }
        XCTAssertNotNil(token)
    }

    func testTriggerAPI() async throws {
        let latestVersion = try await client.latestVersion(for: "ViaVersion")
        XCTAssertNotNil(latestVersion)
    }
}
