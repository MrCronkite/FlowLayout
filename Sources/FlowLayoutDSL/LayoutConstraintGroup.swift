import UIKit

/// The result of a `.layout { }` call.
///
/// Holds every constraint created inside the closure and lets the caller
/// manage their lifecycle afterwards — deactivate them, update them via
/// `.update { }`, or fully rebuild them via `.remake { }`.
@MainActor
public final class LayoutConstraintGroup {
    /// The constraints managed by this group, in creation order.
    public private(set) var constraints: [NSLayoutConstraint]

    init(constraints: [NSLayoutConstraint]) {
        self.constraints = constraints
    }

    /// Activates every constraint in this group in a single batch call.
    public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    /// Deactivates every constraint in this group in a single batch call.
    /// The constraints remain in the group and can be re-activated later.
    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    /// Appends a constraint created during an `.update { }` call that had
    /// no existing match in this group, and activates it immediately.
    /// Internal — only `FlowLayoutProxy` calls this.
    func append(_ constraint: NSLayoutConstraint) {
        constraints.append(constraint)
        constraint.isActive = true
    }

    /// Deactivates every constraint currently in this group, replaces them
    /// with `newConstraints`, and activates the new set in a single batch.
    /// Internal — only `FlowLayoutTarget.remake` calls this.
    func replace(with newConstraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
        constraints = newConstraints
        NSLayoutConstraint.activate(constraints)
    }
}
