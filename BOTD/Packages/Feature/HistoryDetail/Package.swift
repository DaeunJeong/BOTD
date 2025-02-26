// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HistoryDetail",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HistoryDetail",
            targets: ["HistoryDetail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.8.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.2")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/realm/realm-swift.git", branch: "master"),
        .package(path: "../Extension"),
        .package(path: "../CommonUI"),
        .package(path: "../Entity"),
        .package(path: "../Service")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HistoryDetail",
            dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift"), "RxDataSources", "SnapKit",
                           .product(name: "RealmSwift", package: "realm-swift"), "Extension", "CommonUI", "Entity", "Service"]),
        .testTarget(
            name: "HistoryDetailTests",
            dependencies: ["HistoryDetail"]
        ),
    ]
)
