//
//  HangarAPITests.swift
//
//
//  Created by joker on 2023/6/20.
//

import Testing
import HangarAPI
import Foundation

final class HangarAPITests {
    
    let client = HangarAPIClient()
    
    @Test
    func apiAuth() async throws {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
        let token = try await client.authenticate(with: apiKey)
        if let token {
            print(token)
        }
        #expect(token != nil)
    }
    
    @Test
    func fetchPluginInfo() async throws {
        let latestVersion = try await client.latestVersion(for: "ViaVersion")
        #expect(latestVersion != nil)
    }
}
