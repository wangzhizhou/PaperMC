# PaperMC

API for [PaperMC][PaperMC] and Plugin Platform [Hangar][Hangar], include: 

1. [DownloadAPI][DownloadAPI] - [OpenAPI Spec][DownloadAPI OpenAPI Spec]

2. [HangarAPI][HangarAPI] - [OpenAPI Spec][Hangar OpenAPI Spec]

## Usage

```swift

import PackageDescription

let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/wangzhizhou/PaperMC.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Your Target Name",
            dependencies: [
                .product(name: "DownloadAPI", package: "PaperMC"),
                .product(name: "HangarAPI", package: "PaperMC"),
                ...
            ]),
    ]
    ...
)

```


[PaperMC]: <https://papermc.io/>
[Hangar]: <https://hangar.papermc.io/>

[DownloadAPI]: <https://api.papermc.io/docs/swagger-ui/index.html?configUrl=/openapi/swagger-config>
[DownloadAPI OpenAPI Spec]: <https://api.papermc.io/openapi>

[HangarAPI]: <https://hangar.papermc.io/api-docs>
[Hangar OpenAPI Spec]: <https://hangar.papermc.io/v3/api-docs/public>
