// swift-tools-version: 5.6



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
