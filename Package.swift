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
        // Основной продукт — то, что подключает 90% пользователей: `import FlowLayout`
        .library(name: "FlowLayout", targets: ["FlowLayout"]),

        // Точечный продукт для тех, кто хочет собрать свой DSL поверх ядра.
        .library(name: "FlowLayoutCore", targets: ["FlowLayoutCore"])
    ],
    targets: [
        // MARK: - Core
        // Anchor-абстракции, unified target (UIView/UILayoutGuide), priority, inset.
        // Не знает про DSL-синтаксис (.layout { }) — только примитивы.
        .target(
            name: "FlowLayoutCore",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        // MARK: - DSL
        // Публичный fluent/method DSL: .layout { $0.pinTop(...) }
        .target(
            name: "FlowLayoutDSL",
            dependencies: ["FlowLayoutCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        // MARK: - Umbrella
        // Ре-экспортирует Core + DSL для удобного `import FlowLayout`.
        .target(
            name: "FlowLayout",
            dependencies: ["FlowLayoutCore", "FlowLayoutDSL"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        // MARK: - Tests
        .testTarget(
            name: "FlowLayoutCoreTests",
            dependencies: ["FlowLayoutCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "FlowLayoutDSLTests",
            dependencies: ["FlowLayoutDSL"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
