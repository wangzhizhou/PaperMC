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
    
    
    @Test(arguments: [
        "ViaVersion",
        "ViaBackwards",
        "DeathChest",
        "Essentials",
        "Geyser",
        "GriefPrevention",
        "SkinsRestorer",
        "WorldEdit",
    ])
    func fetchPluginInfo(name: String) async throws {
        let latestReleaseVersion = try await client.latestReleaseVersion(for: name)
        #expect(latestReleaseVersion != nil)
    }
    
    @Test(arguments: [
        "BackOnDeath",
        "GetMeHome",
        "LoginSecurity",
        "LuckPerms",
        "Vault",
        "WorldGuard",
    ])
    func doInHangerPlugin(name: String) async throws {
        let latestReleaseVersion = try await client.latestReleaseVersion(for: name)
        #expect(latestReleaseVersion == nil)
    }

    @Test(arguments: [
        "ViaVersion"
    ])
    func versions(name: String) async throws {
        let versions = try #require(await client.versions(for: name))
        #expect(!versions.isEmpty)
        
        let firstVersion = try #require(versions.first)
        let firstVersionName = try #require(firstVersion.name)
        let fetchFirstVersion = try #require(await client.version(for: name, versionName: firstVersionName))
        #expect(fetchFirstVersion == firstVersion)
        
        let httpBody = try await client.downloadPlugin(name: name, version: firstVersionName, platform: .PAPER)
        if case let PluginJavaArchive.Length.known(bytes) = httpBody.length, bytes > 0 {
            let binary = try await Data(collecting: httpBody, upTo: Int(bytes))
            #expect(binary.count == bytes)
        } else {
            Issue.record("download plugin jar failed!")
        }
    }
}
