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
        "GetMeHome",
        "OrzMC",
    ])
    func fetchPluginInfo(name: String) async throws {
        let latestReleaseVersion = try await client.latestReleaseVersion(for: name)
        #expect(latestReleaseVersion != nil)
    }
    
    @Test(arguments: [
        "BackOnDeath",
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
        #expect(fetchFirstVersion.name == firstVersion.name)
        #expect(fetchFirstVersion.createdAt == firstVersion.createdAt)
        #expect(fetchFirstVersion.visibility == firstVersion.visibility)
    }
    
    @Test
    func downloadPluginToFile() async throws {
        let pluginName = "ViaVersion"
        let pluginVersion = "5.2.1"
        let jarFileName = "\(pluginName)_\(pluginVersion).jar"
        let dstFileURL = try #require(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appending(path: jarFileName))
        let progressStream = try #require(await client.downloadPlugin(name: pluginName, version: pluginVersion, platform: .PAPER, toFileURL: dstFileURL))
        for try await progress in progressStream {
            print("\(Int(progress.fractionCompleted * 100))%")
        }
        #expect(FileManager.default.fileExists(atPath: dstFileURL.path()))
        let attributes = try FileManager.default.attributesOfItem(atPath: dstFileURL.path())
        let fileSizeBytes = try #require(attributes[.size] as? Int64)
        #expect(fileSizeBytes > 0)
    }
    
    @Test(arguments: [
        "Via"
    ])
    func searchPlugin(text: String) async throws {
        let projects = try #require(await client.searchPlugin(text: text).0)
        #expect(projects.isEmpty == false)
    }
    
    @Test(arguments: [
        "ViaVersion"
    ])
    func latestVersion(for plugin: String) async throws {
        let latestVersion = try #require(await client.latest(for: plugin, channel: "Release"))
        print(latestVersion)
        #expect(latestVersion.isEmpty == false)
    }
}
