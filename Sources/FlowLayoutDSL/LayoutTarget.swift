import UIKit
import FlowLayoutCore

/// Describes what a pin method should attach to.
///
/// `AnchorType` ties this target to a specific axis via the same generic
/// parameter `FlowAnchor` uses (`NSLayoutXAxisAnchor` / `NSLayoutYAxisAnchor`).
/// This is what makes cross-attribute pinning safe: `pinTop` only accepts
/// `LayoutTarget<NSLayoutYAxisAnchor>`, so `.leading(of:)` (which only exists
/// on the X-axis specialization) is not a candidate — it simply isn't in
/// scope for the compiler to consider. There is no runtime attribute check
/// anywhere in this type.
///
/// Marked `@MainActor` because resolving a target touches
/// `FlowLayoutTarget` members (`flowSuperview`, `flowTopAnchor`, etc.),
/// which are themselves main-actor isolated — `LayoutTarget` doesn't add
/// any isolation of its own, it just needs to run on the same actor as the
/// things it reads.
@MainActor
public struct LayoutTarget<AnchorType: AnyObject> {
    enum Kind {
        case superview
        case safeArea
        case sameAttribute(any FlowLayoutTarget)
        case resolved(FlowAnchor<AnchorType>)
    }

    let kind: Kind

    public static var superview: Self { Self(kind: .superview) }
    public static var safeArea: Self { Self(kind: .safeArea) }

    public static func view(_ target: any FlowLayoutTarget) -> Self {
        Self(kind: .sameAttribute(target))
    }

    public static func guide(_ guide: UILayoutGuide) -> Self {
        Self(kind: .sameAttribute(guide))
    }

    func resolve(
        source: any FlowLayoutTarget,
        sameAttribute: (any FlowLayoutTarget) -> FlowAnchor<AnchorType>
    ) -> FlowAnchor<AnchorType>? {
        switch kind {
        case .superview:
            guard let superview = source.flowSuperview else { return nil }
            return sameAttribute(superview)
        case .safeArea:
            guard let superview = source.flowSuperview else { return nil }
            return sameAttribute(superview.flowSafeArea)
        case .sameAttribute(let target):
            return sameAttribute(target)
        case .resolved(let anchor):
            return anchor
        }
    }
}

// MARK: - Cross-attribute factories (Y axis)

extension LayoutTarget where AnchorType == NSLayoutYAxisAnchor {
    public static func top(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowTopAnchor))
    }

    public static func bottom(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowBottomAnchor))
    }

    public static func centerY(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowCenterYAnchor))
    }
}

// MARK: - Cross-attribute factories (X axis)

extension LayoutTarget where AnchorType == NSLayoutXAxisAnchor {
    public static func leading(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowLeadingAnchor))
    }

    public static func trailing(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowTrailingAnchor))
    }

    public static func left(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowLeftAnchor))
    }

    public static func right(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowRightAnchor))
    }

    public static func centerX(of target: any FlowLayoutTarget) -> Self {
        Self(kind: .resolved(target.flowCenterXAnchor))
    }
}
