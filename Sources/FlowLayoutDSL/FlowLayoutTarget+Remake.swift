import UIKit
import FlowLayoutCore

extension FlowLayoutTarget {
    /// Fully replaces the constraints in `group` with a brand-new set
    /// described by `configure`.
    ///
    /// Unlike `.update { }`, which mutates `constant`/`priority` on existing
    /// constraints in place, `remake` deactivates every constraint in
    /// `group` and builds an entirely new set from scratch — use this when
    /// the *shape* of the layout changes (a different relation, a different
    /// target, a pin that needs to be removed or added), not just a
    /// numeric value. For a numeric-only change, `.update { }` is cheaper
    /// and is the right tool.
    ///
    /// The same `LayoutConstraintGroup` instance is reused and returned, so
    /// any reference you're already holding onto stays valid — only its
    /// `constraints` array is swapped out.
    ///
    /// ```swift
    /// let group = panel.layout { $0.pinHeight(200) }
    ///
    /// // later, switching to a different *shape* of constraint —
    /// // something .update { } cannot do:
    /// panel.remake(group) { $0.pinHeight(to: containerView, multiplier: 0.5) }
    /// ```
    @discardableResult
    public func remake(
        _ group: LayoutConstraintGroup,
        _ configure: (FlowLayoutProxy<Self>) -> Void
    ) -> LayoutConstraintGroup {
        prepareForFlowLayout()

        let builder = ConstraintBuilder()
        let proxy = FlowLayoutProxy(target: self, mode: .create(builder))
        configure(proxy)

        group.replace(with: builder.constraints)
        return group
    }
}