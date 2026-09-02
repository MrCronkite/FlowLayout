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
}
