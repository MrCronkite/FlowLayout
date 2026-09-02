import UIKit

/// A type-safe wrapper around `NSLayoutAnchor<AnchorType>`.
///
/// `FlowAnchor` deliberately does **not** invent a new axis marker system.
/// It reuses the generic parameterization Apple already ships:
/// `NSLayoutXAxisAnchor` is `NSLayoutAnchor<NSLayoutXAxisAnchor>` and
/// `NSLayoutYAxisAnchor` is `NSLayoutAnchor<NSLayoutYAxisAnchor>`. By wrapping
/// the exact same generic parameter, the compiler enforces — for free — that
/// a horizontal anchor can never be paired with a vertical one. There is no
/// runtime check involved; mixing axes is a compile error, not a crash.
///
/// This type is intentionally minimal: it holds a single native anchor and
/// forwards to it. No behavior is duplicated from UIKit.
public struct FlowAnchor<AnchorType: AnyObject>: Sendable {
    /// The underlying UIKit anchor this value wraps.
    public let rawAnchor: NSLayoutAnchor<AnchorType>

    public init(_ rawAnchor: NSLayoutAnchor<AnchorType>) {
        self.rawAnchor = rawAnchor
    }

    /// Creates a constraint against another anchor of the *same* axis.
    ///
    /// Because both anchors share the same `AnchorType`, it is not possible
    /// to call this method with a mismatched axis (e.g. leading vs. top) —
    /// such a call simply does not type-check.
    public func constraint(
        equalTo other: FlowAnchor<AnchorType>,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawAnchor.constraint(equalTo: other.rawAnchor, constant: constant)
    }

    public func constraint(
        greaterThanOrEqualTo other: FlowAnchor<AnchorType>,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawAnchor.constraint(greaterThanOrEqualTo: other.rawAnchor, constant: constant)
    }

    public func constraint(
        lessThanOrEqualTo other: FlowAnchor<AnchorType>,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawAnchor.constraint(lessThanOrEqualTo: other.rawAnchor, constant: constant)
    }
}

/// A horizontal anchor (leading, trailing, left, right, centerX).
public typealias FlowXAxisAnchor = FlowAnchor<NSLayoutXAxisAnchor>

/// A vertical anchor (top, bottom, centerY).
public typealias FlowYAxisAnchor = FlowAnchor<NSLayoutYAxisAnchor>

/// A dimensional anchor (width, height). Wrapped separately from
/// `FlowAnchor` because `NSLayoutDimension` exposes extra capabilities
/// (constant sizing, multiplier-based constraints against another
/// dimension) that plain `NSLayoutAnchor` does not have — see `FlowDimension`.
public struct FlowDimension: Sendable {
    public let rawDimension: NSLayoutDimension

    public init(_ rawDimension: NSLayoutDimension) {
        self.rawDimension = rawDimension
    }

    public func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint {
        rawDimension.constraint(equalToConstant: constant)
    }

    public func constraint(
        greaterThanOrEqualToConstant constant: CGFloat
    ) -> NSLayoutConstraint {
        rawDimension.constraint(greaterThanOrEqualToConstant: constant)
    }

    public func constraint(
        lessThanOrEqualToConstant constant: CGFloat
    ) -> NSLayoutConstraint {
        rawDimension.constraint(lessThanOrEqualToConstant: constant)
    }

    public func constraint(
        equalTo other: FlowDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawDimension.constraint(equalTo: other.rawDimension, multiplier: multiplier, constant: constant)
    }

    public func constraint(
        greaterThanOrEqualTo other: FlowDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawDimension.constraint(
            greaterThanOrEqualTo: other.rawDimension,
            multiplier: multiplier,
            constant: constant
        )
    }

    public func constraint(
        lessThanOrEqualTo other: FlowDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        rawDimension.constraint(
            lessThanOrEqualTo: other.rawDimension,
            multiplier: multiplier,
            constant: constant
        )
    }
}
