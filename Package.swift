// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription

let package = Package(
    name: "xccov2lcov",
    products: [
        .executable(name: "xccov2lcov", targets: ["xccov2lcov"])
    ],
    targets: [
        .target(
            name: "XCCovLib"
        ),
        .executableTarget(
            name: "xccov2lcov",
            dependencies: ["XCCovLib"]
        ),
        .testTarget(
            name: "XCCovLibTests",
            dependencies: ["XCCovLib"]
        )
    ]
)
