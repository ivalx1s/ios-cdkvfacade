//  : 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cdkvfacade-ios",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CoreDataKVFacade",
            type: .dynamic,
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
