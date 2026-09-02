import XCTest
import UIKit
import FlowLayoutDSL

@MainActor
final class LayoutConstraintGroupTests: XCTestCase {
    func test_layout_activatesConstraintsImmediately() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview) }

        XCTAssertTrue(group.constraints.allSatisfy { $0.isActive })
    }

    func test_deactivate_turnsConstraintsOff() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview) }
        group.deactivate()

        XCTAssertTrue(group.constraints.allSatisfy { !$0.isActive })
    }

    func test_activate_afterDeactivate_turnsConstraintsBackOn() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview) }
        group.deactivate()
        group.activate()

        XCTAssertTrue(group.constraints.allSatisfy { $0.isActive })
    }

    func test_group_collectsAllConstraintsFromClosure() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout {
            $0.pinTop(to: .superview, inset: 16)
            $0.pinLeading(to: .superview, inset: 16)
            $0.pinTrailing(to: .superview, inset: 16)
        }

        XCTAssertEqual(group.constraints.count, 3)
    }

    func test_update_mutatesExistingConstraintConstant_withoutCreatingNewOne() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview, inset: 16) }
        XCTAssertEqual(group.constraints.count, 1)

        subview.update(group) { $0.pinTop(to: .superview, inset: 32) }

        XCTAssertEqual(group.constraints.count, 1)
        XCTAssertEqual(group.constraints.first?.constant, 32)
    }

    func test_update_mutatesPriority() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview, priority: .required) }
        subview.update(group) { $0.pinTop(to: .superview, priority: .high) }

        XCTAssertEqual(group.constraints.first?.priority, .defaultHigh)
    }

    func test_update_withUnmatchedPin_appendsAndActivatesNewConstraint() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview, inset: 16) }
        XCTAssertEqual(group.constraints.count, 1)

        subview.update(group) { $0.pinLeading(to: .superview, inset: 8) }

        XCTAssertEqual(group.constraints.count, 2)
        let leading = group.constraints.first { $0.firstAttribute == .leading }
        XCTAssertEqual(leading?.constant, 8)
        XCTAssertTrue(leading?.isActive ?? false)
    }

    func test_update_returnsSameGroupInstance() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview) }
        let returned = subview.update(group) { $0.pinTop(to: .superview, inset: 10) }

        XCTAssertTrue(returned === group)
    }

    func test_remake_deactivatesOldConstraintsAndActivatesNew() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinWidth(100) }
        let oldConstraint = try! XCTUnwrap(group.constraints.first)

        subview.remake(group) { $0.pinWidth(200) }

        XCTAssertFalse(oldConstraint.isActive)
        XCTAssertTrue(group.constraints.first?.isActive ?? false)
    }

    func test_remake_replacesConstraintsArrayEntirely() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinWidth(100) }
        XCTAssertNil(group.constraints.first?.secondItem)

        let other = UIView()
        superview.addSubview(other)
        subview.remake(group) { $0.pinWidth(to: other, multiplier: 0.5) }

        XCTAssertEqual(group.constraints.count, 1)
        let constraint = try! XCTUnwrap(group.constraints.first)
        XCTAssertEqual(constraint.multiplier, 0.5)
        XCTAssertTrue(constraint.secondAnchor === other.widthAnchor)
    }

    func test_remake_returnsSameGroupInstance() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .superview) }
        let returned = subview.remake(group) { $0.pinTop(to: .superview, inset: 10) }

        XCTAssertTrue(returned === group)
    }

    func test_remake_canReduceNumberOfConstraints() {
        let superview = UIView()
        let subview = UIView()
        superview.addSubview(subview)

        let group = subview.layout { $0.pinEdges(to: .superview, inset: 16) }
        XCTAssertEqual(group.constraints.count, 4)

        subview.remake(group) { $0.pinTop(to: .superview, inset: 16) }

        XCTAssertEqual(group.constraints.count, 1)
    }
}
