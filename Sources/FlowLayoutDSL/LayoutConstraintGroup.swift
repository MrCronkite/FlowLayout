import UIKit

/// The result of a `.layout { }` call.
///
/// Holds every constraint created inside the closure and lets the caller
/// manage their lifecycle afterwards — deactivate them, update them via
/// `.update { }`, or (in a later version) fully remake them.
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
    /// Internal — only `FlowLayoutProxy` calls this, from within the same
    /// module.
    func append(_ constraint: NSLayoutConstraint) {
        constraints.append(constraint)
        constraint.isActive = true
    }
}
