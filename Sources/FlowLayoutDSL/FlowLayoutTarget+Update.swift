import UIKit
import FlowLayoutCore

extension FlowLayoutTarget {
    /// Updates constraints previously created by `.layout { }`.
    ///
    /// Each `pin*` call inside `configure` is matched against an existing
    /// constraint in `group` by anchor identity, and only its `constant`
    /// and `priority` are mutated — no constraint is deactivated or
    /// recreated, so this is cheap enough to call from an animation block.
    ///
    /// `relation` and `multiplier` cannot be changed this way — those are
    /// read-only on `NSLayoutConstraint` after creation. A pin describing a
    /// different relation or multiplier than the original silently updates
    /// only the constant/priority; changing relation or multiplier requires
    /// fully recreating the constraint (`remake`, a later version).
    ///
    /// If a pin has no match in `group` (e.g. one added after the original
    /// `.layout { }` call), a new constraint is created, appended to
    /// `group`, and activated immediately.
    ///
    /// ```swift
    /// let group = titleLabel.layout { $0.pinTop(to: .superview, inset: 16) }
    /// // later, in response to a state change:
    /// UIView.animate(withDuration: 0.3) {
    ///     titleLabel.update(group) { $0.pinTop(to: .superview, inset: 32) }
    ///     self.view.layoutIfNeeded()
    /// }
    /// ```
    @discardableResult
    public func update(
        _ group: LayoutConstraintGroup,
        _ configure: (FlowLayoutProxy<Self>) -> Void
    ) -> LayoutConstraintGroup {
        let proxy = FlowLayoutProxy(target: self, mode: .update(group))
        configure(proxy)
        return group
    }
}
