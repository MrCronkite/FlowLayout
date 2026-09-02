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
}
