import UIKit

/// The relation between two sides of a constraint.
///
/// Mirrors `NSLayoutConstraint.Relation`, but is defined as our own type
/// rather than reused directly. This keeps `FlowLayoutDSL` method signatures
/// (`pinTop(relation:)`, etc.) independent of `NSLayoutConstraint` — a
/// deliberate choice per the "minimal dependency on UIKit internals"
/// requirement: only this one file needs to know how `LayoutRelation` maps
/// onto UIKit's own relation type.
public enum LayoutRelation: Sendable, Hashable {
    case equal
    case greaterThanOrEqual
    case lessThanOrEqual
}

extension LayoutRelation {
    /// Bridges to the native UIKit relation. Internal — DSL and Debug layers
    /// use this at the point they actually construct an `NSLayoutConstraint`;
    /// public API surfaces never expose `NSLayoutConstraint.Relation` directly.
    public var uiKitValue: NSLayoutConstraint.Relation {
        switch self {
        case .equal:
            return .equal
        case .greaterThanOrEqual:
            return .greaterThanOrEqual
        case .lessThanOrEqual:
            return .lessThanOrEqual
        }
    }
}
