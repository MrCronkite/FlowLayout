//
//  FlowLayoutTarget.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 01.09.2026.
//


import UIKit

/// Unifies `UIView` and `UILayoutGuide` behind a single interface.
///
/// Both types expose the exact same set of native anchors. SnapKit models
/// them as two separate hierarchies (`ConstraintView` / `ConstraintLayoutGuide`),
/// which duplicates every piece of DSL logic on top. `FlowLayoutTarget`
/// instead makes the anchor surface the single source of truth: every DSL
/// method written above this protocol works identically for a view *or* a
/// layout guide, with no branching.
///
/// This protocol is intentionally anchor-only. It knows nothing about
/// constraint *creation syntax* (`.layout { }`, `pinTop`, etc.) — that is
/// the DSL layer's responsibility. Core only answers the question
/// "what anchors does this thing have, and how do I prepare it for Auto Layout?"
@MainActor
public protocol FlowLayoutTarget: AnyObject {
    var flowLeadingAnchor: FlowXAxisAnchor { get }
    var flowTrailingAnchor: FlowXAxisAnchor { get }
    var flowLeftAnchor: FlowXAxisAnchor { get }
    var flowRightAnchor: FlowXAxisAnchor { get }
    var flowTopAnchor: FlowYAxisAnchor { get }
    var flowBottomAnchor: FlowYAxisAnchor { get }
    var flowCenterXAnchor: FlowXAxisAnchor { get }
    var flowCenterYAnchor: FlowYAxisAnchor { get }
    var flowWidthAnchor: FlowDimension { get }
    var flowHeightAnchor: FlowDimension { get }

    /// The structural parent used to resolve `.superview` targets in the DSL.
    /// For `UIView` this is `superview`; for `UILayoutGuide` this is `owningView`.
    var flowSuperview: UIView? { get }

    /// Called once before any constraint referencing this target is created.
    /// `UIView` uses this to disable `translatesAutoresizingMaskIntoConstraints`.
    /// `UILayoutGuide` has no such flag, so its implementation is a no-op.
    func prepareForFlowLayout()
}

extension UIView: FlowLayoutTarget {
    public var flowLeadingAnchor: FlowXAxisAnchor { FlowAnchor(leadingAnchor) }
    public var flowTrailingAnchor: FlowXAxisAnchor { FlowAnchor(trailingAnchor) }
    public var flowLeftAnchor: FlowXAxisAnchor { FlowAnchor(leftAnchor) }
    public var flowRightAnchor: FlowXAxisAnchor { FlowAnchor(rightAnchor) }
    public var flowTopAnchor: FlowYAxisAnchor { FlowAnchor(topAnchor) }
    public var flowBottomAnchor: FlowYAxisAnchor { FlowAnchor(bottomAnchor) }
    public var flowCenterXAnchor: FlowXAxisAnchor { FlowAnchor(centerXAnchor) }
    public var flowCenterYAnchor: FlowYAxisAnchor { FlowAnchor(centerYAnchor) }
    public var flowWidthAnchor: FlowDimension { FlowDimension(widthAnchor) }
    public var flowHeightAnchor: FlowDimension { FlowDimension(heightAnchor) }

    public var flowSuperview: UIView? { superview }

    public func prepareForFlowLayout() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }

    /// The view's safe area, exposed as a `FlowLayoutTarget` so it can be
    /// used anywhere a regular target is accepted (e.g. as a pin destination).
    public var flowSafeArea: UILayoutGuide { safeAreaLayoutGuide }
}

extension UILayoutGuide: FlowLayoutTarget {
    public var flowLeadingAnchor: FlowXAxisAnchor { FlowAnchor(leadingAnchor) }
    public var flowTrailingAnchor: FlowXAxisAnchor { FlowAnchor(trailingAnchor) }
    public var flowLeftAnchor: FlowXAxisAnchor { FlowAnchor(leftAnchor) }
    public var flowRightAnchor: FlowXAxisAnchor { FlowAnchor(rightAnchor) }
    public var flowTopAnchor: FlowYAxisAnchor { FlowAnchor(topAnchor) }
    public var flowBottomAnchor: FlowYAxisAnchor { FlowAnchor(bottomAnchor) }
    public var flowCenterXAnchor: FlowXAxisAnchor { FlowAnchor(centerXAnchor) }
    public var flowCenterYAnchor: FlowYAxisAnchor { FlowAnchor(centerYAnchor) }
    public var flowWidthAnchor: FlowDimension { FlowDimension(widthAnchor) }
    public var flowHeightAnchor: FlowDimension { FlowDimension(heightAnchor) }

    public var flowSuperview: UIView? { owningView }

    public func prepareForFlowLayout() {
        // UILayoutGuide has no translatesAutoresizingMaskIntoConstraints flag.
    }
}
