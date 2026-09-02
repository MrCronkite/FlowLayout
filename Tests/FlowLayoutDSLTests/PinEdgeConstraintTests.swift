//
//  PinEdgeConstraintTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutDSL

@MainActor
final class PinEdgeConstraintTests: XCTestCase {
    private var superview: UIView!
    private var subview: UIView!

    override func setUp() {
        super.setUp()
        superview = UIView()
        subview = UIView()
        superview.addSubview(subview)
    }

    override func tearDown() {
        superview = nil
        subview = nil
        super.tearDown()
    }

    func test_pinTop_toSuperview_positiveInsetProducesPositiveConstant() {
        let group = subview.layout { $0.pinTop(to: .superview, inset: 16) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, 16)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertTrue(constraint.firstAnchor === subview.topAnchor)
        XCTAssertTrue(constraint.secondAnchor === superview.topAnchor)
    }

    func test_pinBottom_toSuperview_positiveInsetProducesNegativeConstant() {
        let group = subview.layout { $0.pinBottom(to: .superview, inset: 16) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, -16)
        XCTAssertTrue(constraint.secondAnchor === superview.bottomAnchor)
    }

    func test_pinLeading_toSuperview_positiveInsetProducesPositiveConstant() {
        let group = subview.layout { $0.pinLeading(to: .superview, inset: 16) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, 16)
    }

    func test_pinTrailing_toSuperview_positiveInsetProducesNegativeConstant() {
        let group = subview.layout { $0.pinTrailing(to: .superview, inset: 16) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, -16)
    }

    func test_pin_activatesConstraintAutomatically() {
        let group = subview.layout { $0.pinTop(to: .superview) }
        XCTAssertTrue(group.constraints.first?.isActive ?? false)
    }

    func test_pin_disablesTranslatesAutoresizingMaskIntoConstraints() {
        XCTAssertTrue(subview.translatesAutoresizingMaskIntoConstraints)

        _ = subview.layout { $0.pinTop(to: .superview) }

        XCTAssertFalse(subview.translatesAutoresizingMaskIntoConstraints)
    }

    func test_pinTop_setsPriority() {
        let group = subview.layout { $0.pinTop(to: .superview, priority: .high) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.priority, .defaultHigh)
    }

    func test_pinTop_greaterThanOrEqual_setsRelation() {
        let group = subview.layout { $0.pinTop(to: .superview, relation: .greaterThanOrEqual, inset: 8) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func test_pin_setsReadableIdentifier() {
        let group = subview.layout { $0.pinTop(to: .superview) }
        let identifier = try! XCTUnwrap(group.constraints.first?.identifier)

        XCTAssertTrue(identifier.hasPrefix("FlowLayout:"))
        XCTAssertTrue(identifier.contains("PinEdgeConstraintTests"))
    }

    func test_pinCenterX_usesOffsetDirectly_noSignFlip() {
        let group = subview.layout { $0.pinCenterX(to: .superview, offset: -10) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, -10)
    }

    func test_pinWidth_constant() {
        let group = subview.layout { $0.pinWidth(120) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.constant, 120)
        XCTAssertNil(constraint.secondItem)
    }

    func test_pinWidth_relativeToOtherView_appliesMultiplier() {
        let other = UIView()
        let group = subview.layout { $0.pinWidth(to: other, multiplier: 0.5, offset: 4) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertEqual(constraint.multiplier, 0.5)
        XCTAssertEqual(constraint.constant, 4)
        XCTAssertTrue(constraint.secondAnchor === other.widthAnchor)
    }
}