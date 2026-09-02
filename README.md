# FlowLayout

A type-safe, expressive Swift DSL for UIKit Auto Layout — built from the ground up for Swift 6, not a port of an older API.

FlowLayout replaces long chains of `NSLayoutConstraint.activate([...])` with a small set of `pin*` methods that read like plain English, while staying fully type-safe: mixing a horizontal anchor with a vertical one, or a width with a height, is a **compile error**, not a runtime crash.

```swift
titleLabel.layout {
    $0.pinTop(to: .superview, inset: 16)
    $0.pinLeading(to: .superview, inset: 16)
    $0.pinTrailing(to: .superview, inset: 16)
}
```

## Why FlowLayout

Most Auto Layout DSLs (including the ones that came before Swift's anchors were generic) route every attribute through a shared enum internally, which means a constraint like "top equal to leading" type-checks fine and only fails at runtime. FlowLayout instead reuses the same generic parameterization Apple already ships on `NSLayoutXAxisAnchor` / `NSLayoutYAxisAnchor` / `NSLayoutDimension`, so that protection comes from the compiler, not from an internal runtime check.

- **Type-safe by construction** — no attribute enums, no runtime assertions for axis mismatches.
- **One unified API for `UIView` and `UILayoutGuide`** — including the safe area — no parallel APIs to learn.
- **Batch activation** — every constraint declared in a `.layout { }` block activates in a single call.
- **Update and remake** — cheap in-place value changes (`update`) and full constraint-set rebuilds (`remake`) for dynamic layouts and animations.
- **Built-in diagnostics** — every constraint gets a readable `identifier` (`file:line`) automatically, plus an optional ambiguity detector.
- **Swift 6 native** — `@MainActor` isolation throughout, no `@preconcurrency` escape hatches.

## Requirements

- iOS 15+
- Swift 6.0+
- Xcode 16+

## Installation

### Swift Package Manager

Add FlowLayout as a dependency in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MrCronkite/FlowLayout.git", from: "0.1.0")
]
```

Or in Xcode: **File → Add Package Dependencies…** and paste the repository URL.

Import the umbrella module — it re-exports everything you need:

```swift
import FlowLayout
```

## Usage

### Basic constraints

```swift
titleLabel.layout {
    $0.pinTop(to: .superview, inset: 16)
    $0.pinLeading(to: .superview, inset: 16)
    $0.pinTrailing(to: .superview, inset: 16)
}
```

### Edges, center, and size in one call

```swift
avatarImageView.layout {
    $0.pinSize(CGSize(width: 48, height: 48))
    $0.pinCenter(to: .superview)
}

cardView.layout {
    $0.pinEdges(to: .superview, inset: 16)
}
```

### Cross-attribute pinning

Pin one edge to a *different* edge on another view — the classic "stack these labels vertically" case:

```swift
subtitleLabel.layout {
    $0.pinTop(to: .bottom(of: titleLabel), inset: 8)
    $0.pinLeading(to: .superview, inset: 16)
}
```

### Safe area, priorities, relations

```swift
actionButton.layout {
    $0.pinBottom(to: .safeArea, inset: 24, priority: .high)
    $0.pinWidth(to: containerView, multiplier: 0.5)
    $0.pinHeight(44, relation: .greaterThanOrEqual)
}
```

### Updating constraints

`update` mutates `constant`/`priority` on an existing set of constraints in place — cheap enough to call inside an animation block:

```swift
let group = panel.layout { $0.pinHeight(0) }

UIView.animate(withDuration: 0.3) {
    panel.update(group) { $0.pinHeight(200) }
    self.view.layoutIfNeeded()
}
```

### Remaking constraints

When the *shape* of a layout changes — a different relation, a different target, more or fewer pins — `remake` deactivates the old set and builds a new one from scratch, reusing the same `LayoutConstraintGroup` reference:

```swift
panel.remake(group) {
    $0.pinHeight(to: containerView, multiplier: 0.5)
}
```

### Diagnostics

```swift
import FlowLayoutDebug

FlowLayoutDebugger.printAmbiguityReport(in: view)
```

Every constraint FlowLayout creates already carries a `file:line` identifier, so Auto Layout's own console warnings are readable out of the box — no extra setup required.

## Architecture

FlowLayout is split into independent modules so you only pay for what you use:

| Module | Contains |
|---|---|
| `FlowLayoutCore` | Anchor abstractions, unified `UIView`/`UILayoutGuide` target protocol, `LayoutPriority`, `LayoutRelation` |
| `FlowLayoutDSL` | The `pin*` DSL, `.layout`/`.update`/`.remake` |
| `FlowLayoutDebug` | Ambiguity detection and layout diagnostics — no dependency on Core or DSL |
| `FlowLayout` | Umbrella module re-exporting Core + DSL for `import FlowLayout` |

## Status

FlowLayout is under active development. The current release covers basic constraints, edges/center/size, safe area, priorities, cross-attribute pinning, update, remake, and diagnostics. A result-builder DSL and `UIStackView` support are planned for future releases — see [Issues](../../issues) for the current roadmap.

## Contributing

Issues and pull requests are welcome. If you're proposing a change to the public API, please open an issue first to discuss the design.

## License

FlowLayout is available under the MIT license.
