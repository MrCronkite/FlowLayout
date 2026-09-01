// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FlowLayout",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Основной продукт — то, что подключает 90% пользователей: `import FlowLayout`
        .library(name: "FlowLayout", targets: ["FlowLayout"]),

        // Точечные продукты для тех, кто хочет собрать свой DSL поверх ядра,
        // или не хочет тянуть result-builder API.
        .library(name: "FlowLayoutCore", targets: ["FlowLayoutCore"]),
        .library(name: "FlowLayoutBuilder", targets: ["FlowLayoutBuilder"]),
        .library(name: "FlowLayoutDebug", targets: ["FlowLayoutDebug"])
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

        // MARK: - Result Builder DSL (опциональный модуль, начиная с 0.6 по роадмапу)
        .target(
            name: "FlowLayoutBuilder",
            dependencies: ["FlowLayoutCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        // MARK: - Debug
        // Диагностика конфликтов, ambiguity-детектор. Не тянется в релиз, если не нужен.
        .target(
            name: "FlowLayoutDebug",
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
        ),
        .testTarget(
            name: "FlowLayoutBuilderTests",
            dependencies: ["FlowLayoutBuilder"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
