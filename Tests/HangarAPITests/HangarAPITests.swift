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
    let hangerAPITestOnlyAPIKey = "3e5095b0-b2ef-472c-bda8-2abbff03458b.a2ea9d80-5cc8-4452-afe4-a0a8e5d1f9cc"
    
    @Test
    func apiAuth() async throws {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? hangerAPITestOnlyAPIKey
        let token = try await client.authenticate(with: apiKey)
        #expect(token != nil)
    }
    
    @Test
    func fetchPluginInfo() async throws {
        let latestVersion = try await client.latestVersion(for: "ViaVersion")
        #expect(latestVersion != nil)
    }
}
