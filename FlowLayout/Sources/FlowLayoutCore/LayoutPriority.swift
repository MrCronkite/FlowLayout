//
//  LayoutPriority.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 01.09.2026.
//


import UIKit

/// A type-safe wrapper around `UILayoutPriority`.
///
/// Exists mainly so call sites can write `priority: 750` or `priority: .high`
/// instead of `UILayoutPriority(rawValue: 750)`, while still keeping the
/// value strongly typed (a raw `Float` in a DSL method signature would be
/// easy to confuse with `constant:` or `multiplier:`).
public struct LayoutPriority: Sendable, Hashable {
    public let rawValue: Float

    public init(_ rawValue: Float) {
        self.rawValue = rawValue
    }

    public init(_ priority: UILayoutPriority) {
        self.rawValue = priority.rawValue
    }

    /// The constraint must be satisfied. Violating it is a layout error.
    public static let required = LayoutPriority(UILayoutPriority.required)

    /// The highest priority a view can request without requiring it.
    public static let high = LayoutPriority(UILayoutPriority.defaultHigh)

    /// The default priority for content hugging / compression resistance.
    public static let low = LayoutPriority(UILayoutPriority.defaultLow)

    /// The priority used when a view is sized to fit its content.
    public static let fittingSize = LayoutPriority(UILayoutPriority.fittingSizeLevel)

    var uiKitValue: UILayoutPriority { UILayoutPriority(rawValue) }
}

extension LayoutPriority: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.rawValue = Float(value)
    }
}

extension LayoutPriority: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.rawValue = Float(value)
    }
}

extension LayoutPriority: Comparable {
    public static func < (lhs: LayoutPriority, rhs: LayoutPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}