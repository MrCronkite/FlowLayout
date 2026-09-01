import XCTest
import UIKit
import FlowLayoutCore

@MainActor
final class FlowAnchorTests: XCTestCase {
    func test_equalTo_forwardsConstantAndAnchorsToNativeConstraint() {
        let view = UIView()
        let other = UIView()

        let constraint = FlowAnchor(view.topAnchor)
            .constraint(equalTo: FlowAnchor(other.topAnchor), constant: 12)

        XCTAssertTrue(constraint.firstAnchor === view.topAnchor)
        XCTAssertTrue(constraint.secondAnchor === other.topAnchor)
        XCTAssertEqual(constraint.constant, 12)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func test_greaterThanOrEqualTo_setsCorrectRelation() {
        let view = UIView()
        let other = UIView()

        let constraint = FlowAnchor(view.leadingAnchor)
            .constraint(greaterThanOrEqualTo: FlowAnchor(other.leadingAnchor))

        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func test_lessThanOrEqualTo_setsCorrectRelation() {
        let view = UIView()
        let other = UIView()

        let constraint = FlowAnchor(view.trailingAnchor)
            .constraint(lessThanOrEqualTo: FlowAnchor(other.trailingAnchor))

        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    func test_dimension_equalToConstant_producesNoSecondItem() {
        let view = UIView()

        let constraint = FlowDimension(view.widthAnchor).constraint(equalToConstant: 44)

        XCTAssertTrue(constraint.firstAnchor === view.widthAnchor)
        XCTAssertEqual(constraint.constant, 44)
        XCTAssertNil(constraint.secondItem)
    }

    func test_dimension_equalToOtherDimension_appliesMultiplierAndConstant() {
        let view = UIView()
        let other = UIView()

        let constraint = FlowDimension(view.widthAnchor)
            .constraint(equalTo: FlowDimension(other.widthAnchor), multiplier: 0.5, constant: 4)

        XCTAssertTrue(constraint.secondAnchor === other.widthAnchor)
        XCTAssertEqual(constraint.multiplier, 0.5)
        XCTAssertEqual(constraint.constant, 4)
    }

    func test_dimension_greaterThanOrEqualToConstant_setsCorrectRelation() {
        let view = UIView()

        let constraint = FlowDimension(view.heightAnchor).constraint(greaterThanOrEqualToConstant: 20)

        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func test_dimension_lessThanOrEqualToConstant_setsCorrectRelation() {
        let view = UIView()

        let constraint = FlowDimension(view.heightAnchor).constraint(lessThanOrEqualToConstant: 200)

        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }
}
