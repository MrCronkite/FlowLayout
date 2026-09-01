import UIKit
import FlowLayoutCore

/// An axis-agnostic target used by composite pin methods (`pinEdges`,
/// `pinCenter`) that need to resolve both an X-axis and a Y-axis anchor
/// from the same destination.
///
/// `LayoutTarget<AnchorType>` can't be reused directly here because it is
/// specialized per axis. `LayoutContainer` sits one level above it and
/// converts itself into the right `LayoutTarget` specialization for each
/// individual pin call the composite method makes.
///
/// Marked `@MainActor` for the same reason as `LayoutTarget`: converting
/// to an axis-specific target calls into `LayoutTarget`'s own
/// main-actor-isolated static members.
@MainActor
public struct LayoutContainer {
    enum Kind {
        case superview
        case safeArea
        case target(any FlowLayoutTarget)
    }

    let kind: Kind

    public static var superview: Self { Self(kind: .superview) }
    public static var safeArea: Self { Self(kind: .safeArea) }

    public static func view(_ target: any FlowLayoutTarget) -> Self {
        Self(kind: .target(target))
    }

    public static func guide(_ guide: UILayoutGuide) -> Self {
        Self(kind: .target(guide))
    }

    var asXAxisTarget: LayoutTarget<NSLayoutXAxisAnchor> {
        switch kind {
        case .superview: return .superview
        case .safeArea: return .safeArea
        case .target(let target): return .view(target)
        }
    }

    var asYAxisTarget: LayoutTarget<NSLayoutYAxisAnchor> {
        switch kind {
        case .superview: return .superview
        case .safeArea: return .safeArea
        case .target(let target): return .view(target)
        }
    }
}
