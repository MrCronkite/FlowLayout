import UIKit
import FlowLayoutCore

/// The object passed into a `.layout { }` closure (conventionally bound as
/// `$0`). Every `pin*` method here creates one `NSLayoutConstraint`,
/// hands it to the enclosing `ConstraintBuilder`, and returns `self` so
/// calls can optionally be chained — but chaining is never required; each
/// call also works fine as its own statement, which is the style this DSL
/// is designed around:
///
/// ```swift
/// titleLabel.layout {
///     $0.pinTop(to: .superview, inset: 16)
///     $0.pinLeading(to: .superview, inset: 16)
///     $0.pinTrailing(to: .superview, inset: 16)
/// }
/// ```
///
/// Inset semantics: `inset` always means "inward", regardless of edge.
/// `pinTop(inset: 16)` pushes the edge down by 16 (`constant: +16`);
/// `pinBottom(inset: 16)` pulls the edge up by 16 (`constant: -16`). This
/// is a deliberate difference from raw `NSLayoutConstraint`, where the sign
/// of `constant` must be worked out by hand for every edge.
@MainActor
public struct FlowLayoutProxy<Base: FlowLayoutTarget> {
    let target: Base
    let builder: ConstraintBuilder

    // MARK: - Edges

    @discardableResult
    public func pinTop(
        to target: LayoutTarget<NSLayoutYAxisAnchor>,
        relation: LayoutRelation = .equal,
        inset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowTopAnchor,
            to: target,
            sameAttribute: \.flowTopAnchor,
            relation: relation,
            constant: inset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    public func pinBottom(
        to target: LayoutTarget<NSLayoutYAxisAnchor>,
        relation: LayoutRelation = .equal,
        inset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowBottomAnchor,
            to: target,
            sameAttribute: \.flowBottomAnchor,
            relation: relation,
            constant: -inset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    public func pinLeading(
        to target: LayoutTarget<NSLayoutXAxisAnchor>,
        relation: LayoutRelation = .equal,
        inset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowLeadingAnchor,
            to: target,
            sameAttribute: \.flowLeadingAnchor,
            relation: relation,
            constant: inset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    public func pinTrailing(
        to target: LayoutTarget<NSLayoutXAxisAnchor>,
        relation: LayoutRelation = .equal,
        inset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowTrailingAnchor,
            to: target,
            sameAttribute: \.flowTrailingAnchor,
            relation: relation,
            constant: -inset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    // MARK: - Center

    @discardableResult
    public func pinCenterX(
        to target: LayoutTarget<NSLayoutXAxisAnchor>,
        relation: LayoutRelation = .equal,
        offset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowCenterXAnchor,
            to: target,
            sameAttribute: \.flowCenterXAnchor,
            relation: relation,
            constant: offset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    public func pinCenterY(
        to target: LayoutTarget<NSLayoutYAxisAnchor>,
        relation: LayoutRelation = .equal,
        offset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addEdgeConstraint(
            ownAnchor: self.target.flowCenterYAnchor,
            to: target,
            sameAttribute: \.flowCenterYAnchor,
            relation: relation,
            constant: offset,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    // MARK: - Size

    @discardableResult
    public func pinWidth(
        _ constant: CGFloat,
        relation: LayoutRelation = .equal,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addDimensionConstraint(
            dimension: target.flowWidthAnchor,
            constant: constant,
            relation: relation,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    public func pinHeight(
        _ constant: CGFloat,
        relation: LayoutRelation = .equal,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addDimensionConstraint(
            dimension: target.flowHeightAnchor,
            constant: constant,
            relation: relation,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    /// Pins width relative to another target's width (e.g. `pinWidth(to: other, multiplier: 0.5)`).
    @discardableResult
    public func pinWidth(
        to other: any FlowLayoutTarget,
        multiplier: CGFloat = 1,
        offset: CGFloat = 0,
        relation: LayoutRelation = .equal,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addRelativeDimensionConstraint(
            dimension: target.flowWidthAnchor,
            to: other.flowWidthAnchor,
            multiplier: multiplier,
            constant: offset,
            relation: relation,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    /// Pins height relative to another target's height.
    @discardableResult
    public func pinHeight(
        to other: any FlowLayoutTarget,
        multiplier: CGFloat = 1,
        offset: CGFloat = 0,
        relation: LayoutRelation = .equal,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        addRelativeDimensionConstraint(
            dimension: target.flowHeightAnchor,
            to: other.flowHeightAnchor,
            multiplier: multiplier,
            constant: offset,
            relation: relation,
            priority: priority,
            file: file,
            line: line
        )
        return self
    }

    // MARK: - Composite: edges

    /// Pins all four edges to the same container with a single inset.
    ///
    /// ```swift
    /// titleLabel.layout { $0.pinEdges(to: .superview, inset: 16) }
    /// ```
    @discardableResult
    public func pinEdges(
        to container: LayoutContainer,
        inset: CGFloat = 0,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        pinTop(to: container.asYAxisTarget, inset: inset, priority: priority, file: file, line: line)
        pinLeading(to: container.asXAxisTarget, inset: inset, priority: priority, file: file, line: line)
        pinTrailing(to: container.asXAxisTarget, inset: inset, priority: priority, file: file, line: line)
        pinBottom(to: container.asYAxisTarget, inset: inset, priority: priority, file: file, line: line)
        return self
    }

    /// Pins all four edges to the same container with independent insets per edge.
    @discardableResult
    public func pinEdges(
        to container: LayoutContainer,
        insets: UIEdgeInsets,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        pinTop(to: container.asYAxisTarget, inset: insets.top, priority: priority, file: file, line: line)
        pinLeading(to: container.asXAxisTarget, inset: insets.left, priority: priority, file: file, line: line)
        pinTrailing(to: container.asXAxisTarget, inset: insets.right, priority: priority, file: file, line: line)
        pinBottom(to: container.asYAxisTarget, inset: insets.bottom, priority: priority, file: file, line: line)
        return self
    }

    // MARK: - Composite: center

    @discardableResult
    public func pinCenter(
        to container: LayoutContainer,
        offset: CGPoint = .zero,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        pinCenterX(to: container.asXAxisTarget, offset: offset.x, priority: priority, file: file, line: line)
        pinCenterY(to: container.asYAxisTarget, offset: offset.y, priority: priority, file: file, line: line)
        return self
    }

    // MARK: - Composite: size

    @discardableResult
    public func pinSize(
        _ size: CGSize,
        priority: LayoutPriority = .required,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        pinWidth(size.width, priority: priority, file: file, line: line)
        pinHeight(size.height, priority: priority, file: file, line: line)
        return self
    }

    // MARK: - Private helpers

    private func addEdgeConstraint<AnchorType>(
        ownAnchor: FlowAnchor<AnchorType>,
        to target: LayoutTarget<AnchorType>,
        sameAttribute: (any FlowLayoutTarget) -> FlowAnchor<AnchorType>,
        relation: LayoutRelation,
        constant: CGFloat,
        priority: LayoutPriority,
        file: StaticString,
        line: UInt
    ) {
        guard let otherAnchor = target.resolve(source: self.target, sameAttribute: sameAttribute) else {
            assertionFailure(
                "FlowLayout: could not resolve layout target at \(file):\(line) — " +
                "the view has no superview yet. Add it to the hierarchy before calling .layout { }."
            )
            return
        }

        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = ownAnchor.constraint(equalTo: otherAnchor, constant: constant)
        case .greaterThanOrEqual:
            constraint = ownAnchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        case .lessThanOrEqual:
            constraint = ownAnchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        }

        constraint.priority = priority.uiKitValue
        constraint.identifier = "FlowLayout: \(file):\(line)"
        builder.add(constraint)
    }

    private func addDimensionConstraint(
        dimension: FlowDimension,
        constant: CGFloat,
        relation: LayoutRelation,
        priority: LayoutPriority,
        file: StaticString,
        line: UInt
    ) {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = dimension.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        }

        constraint.priority = priority.uiKitValue
        constraint.identifier = "FlowLayout: \(file):\(line)"
        builder.add(constraint)
    }

    private func addRelativeDimensionConstraint(
        dimension: FlowDimension,
        to other: FlowDimension,
        multiplier: CGFloat,
        constant: CGFloat,
        relation: LayoutRelation,
        priority: LayoutPriority,
        file: StaticString,
        line: UInt
    ) {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = dimension.constraint(equalTo: other, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            constraint = dimension.constraint(greaterThanOrEqualTo: other, multiplier: multiplier, constant: constant)
        case .lessThanOrEqual:
            constraint = dimension.constraint(lessThanOrEqualTo: other, multiplier: multiplier, constant: constant)
        }

        constraint.priority = priority.uiKitValue
        constraint.identifier = "FlowLayout: \(file):\(line)"
        builder.add(constraint)
    }
}
