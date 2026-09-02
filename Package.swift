// swift-tools-version: 6.0
import PackageDescription

// NOTE: FlowLayoutBuilder (result-builder DSL, milestone 0.6) and
// FlowLayoutDebug (diagnostics, milestone 0.5) are intentionally not
// declared yet. SwiftPM rejects a target directory that has zero source
// files ("target ... is empty"), so the manifest only lists targets that
// currently contain real code. Both will be added back once we reach
// those milestones and write their first file.

let package = Package(
    name: "FlowLayout",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "FlowLayout", targets: ["FlowLayout"]),
        .library(name: "FlowLayoutCore", targets: ["FlowLayoutCore"]),
        .library(name: "FlowLayoutDebug", targets: ["FlowLayoutDebug"])
    ],
    targets: [
        .target(
            name: "FlowLayoutCore",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "FlowLayoutDSL",
            dependencies: ["FlowLayoutCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "FlowLayoutDebug",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "FlowLayout",
            dependencies: ["FlowLayoutCore", "FlowLayoutDSL"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "FlowLayoutCoreTests",
            dependencies: ["FlowLayoutCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "FlowLayoutDSLTests",
            dependencies: ["FlowLayoutDSL"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "FlowLayoutDebugTests",
            dependencies: ["FlowLayoutDebug", "FlowLayoutDSL"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
