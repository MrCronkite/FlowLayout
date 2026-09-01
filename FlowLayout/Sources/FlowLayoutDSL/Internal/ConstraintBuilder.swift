import UIKit

/// Collects constraints created inside a `.layout { }` closure without
/// activating them immediately. Activation happens once, in a single
/// `NSLayoutConstraint.activate(_:)` call, after the closure finishes —
/// this avoids transient conflicting states and is measurably faster than
/// activating constraints one at a time.
///
/// Internal to the DSL layer: public API never touches this type directly,
/// only the `LayoutConstraintGroup` it produces.
@MainActor
final class ConstraintBuilder {
    private(set) var constraints: [NSLayoutConstraint] = []

    func add(_ constraint: NSLayoutConstraint) {
        constraints.append(constraint)
    }
}
