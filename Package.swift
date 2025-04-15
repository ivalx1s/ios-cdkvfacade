// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ios-cdkvfacade",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CoreDataKVFacade",
            targets: ["CoreDataKVFacade"]
        ),
    ],
    targets: [
        .target(
            name: "CoreDataKVFacade",
            path: "Sources"
        ),
    ]
)
