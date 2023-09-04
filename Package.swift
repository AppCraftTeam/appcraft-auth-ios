// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACAuth",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ACAuth",
            targets: ["ACAuth"]
        )
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.14.0")
        ),
        .package(
            name: "Facebook",
            url: "https://github.com/facebook/facebook-ios-sdk.git",
            .upToNextMajor(from: "16.1.3")
        ),
        .package(
            name: "GoogleSignIn",
            url: "https://github.com/google/GoogleSignIn-iOS",
            .upToNextMajor(from: "7.0.0")
        )
    ],
    targets: [
        .target(
            name: "ACAuth",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FacebookLogin", package: "Facebook"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ACAuthTests",
            dependencies: ["ACAuth"]
        )
    ]
)
