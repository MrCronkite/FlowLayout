import UIKit

/// The result of a `.layout { }` call.
///
/// Holds every constraint created inside the closure and lets the caller
/// manage their lifecycle afterwards — deactivate them, or (starting with
/// the 0.4 milestone) update or fully remake them. Kept as a reference type
/// so a single group can be stored and mutated across multiple points in a
/// view controller's lifecycle.
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
}
