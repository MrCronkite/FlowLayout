import UIKit
import FlowLayoutCore

extension FlowLayoutTarget {
    /// Declares constraints for this view or layout guide.
    ///
    /// Every constraint created inside `configure` is collected first and
    /// activated once, in a single batch, after the closure returns — never
    /// one-by-one as each `pin*` call happens. The returned
    /// ``LayoutConstraintGroup`` can be kept around to deactivate, update,
    /// or (in a later version) remake the same set of constraints.
    ///
    /// ```swift
    /// let group = titleLabel.layout {
    ///     $0.pinTop(to: .superview, inset: 16)
    ///     $0.pinLeading(to: .superview, inset: 16)
    ///     $0.pinTrailing(to: .superview, inset: 16)
    /// }
    /// ```
    @discardableResult
    public func layout(
        _ configure: (FlowLayoutProxy<Self>) -> Void
    ) -> LayoutConstraintGroup {
        prepareForFlowLayout()

        let builder = ConstraintBuilder()
        let proxy = FlowLayoutProxy(target: self, builder: builder)
        configure(proxy)

        let group = LayoutConstraintGroup(constraints: builder.constraints)
        group.activate()
        return group
    }
}
