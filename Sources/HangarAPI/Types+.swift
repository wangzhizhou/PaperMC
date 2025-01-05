import OpenAPIRuntime
public typealias PluginVersion = Components.Schemas.Version
public typealias PluginPlatform = Components.Schemas.Platform
public typealias PluginJavaArchive = OpenAPIRuntime.HTTPBody
public typealias PluginProject = Components.Schemas.Project
public typealias PluginSearchPagination = Components.Schemas.RequestPagination
public typealias PluginPagination = Components.Schemas.Pagination
public typealias PluginPlatformVersionDownload = Components.Schemas.PlatformVersionDownload

import Foundation
public extension PluginPlatformVersionDownload {
    var downloadURL: URL? {
        guard let downloadUrl = self.downloadUrl ?? self.externalUrl
        else {
            return nil
        }
        return URL(string: downloadUrl)
    }
}
