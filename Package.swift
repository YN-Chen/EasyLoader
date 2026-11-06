// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EasyLoader",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "EasyLoader", targets: ["EasyLoader"])
    ],
    targets: [
        .target(name: "EasyLoader"),
        .testTarget(name: "EasyLoaderTests", dependencies: ["EasyLoader"])
    ]
)
