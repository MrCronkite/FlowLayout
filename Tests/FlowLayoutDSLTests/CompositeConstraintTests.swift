//
//  CompositeConstraintTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutDSL

@MainActor
final class CompositeConstraintTests: XCTestCase {
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

    func test_pinEdges_createsFourConstraintsWithMatchingInset() {
        let group = subview.layout { $0.pinEdges(to: .superview, inset: 16) }
        XCTAssertEqual(group.constraints.count, 4)

        let top = group.constraints.first { $0.firstAttribute == .top }
        let bottom = group.constraints.first { $0.firstAttribute == .bottom }
        let leading = group.constraints.first { $0.firstAttribute == .leading }
        let trailing = group.constraints.first { $0.firstAttribute == .trailing }

        XCTAssertEqual(top?.constant, 16)
        XCTAssertEqual(leading?.constant, 16)
        XCTAssertEqual(bottom?.constant, -16)
        XCTAssertEqual(trailing?.constant, -16)
    }

    func test_pinEdges_withUIEdgeInsets_appliesPerEdgeValues() {
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        let group = subview.layout { $0.pinEdges(to: .superview, insets: insets) }

        let top = group.constraints.first { $0.firstAttribute == .top }
        let leading = group.constraints.first { $0.firstAttribute == .leading }
        let bottom = group.constraints.first { $0.firstAttribute == .bottom }
        let trailing = group.constraints.first { $0.firstAttribute == .trailing }

        XCTAssertEqual(top?.constant, 10)
        XCTAssertEqual(leading?.constant, 20)
        XCTAssertEqual(bottom?.constant, -30)
        XCTAssertEqual(trailing?.constant, -40)
    }

    func test_pinCenter_createsTwoConstraintsWithOffset() {
        let group = subview.layout { $0.pinCenter(to: .superview, offset: CGPoint(x: 5, y: -5)) }
        XCTAssertEqual(group.constraints.count, 2)

        let centerX = group.constraints.first { $0.firstAttribute == .centerX }
        let centerY = group.constraints.first { $0.firstAttribute == .centerY }

        XCTAssertEqual(centerX?.constant, 5)
        XCTAssertEqual(centerY?.constant, -5)
    }

    func test_pinSize_createsWidthAndHeightConstraints() {
        let group = subview.layout { $0.pinSize(CGSize(width: 100, height: 44)) }
        XCTAssertEqual(group.constraints.count, 2)

        let width = group.constraints.first { $0.firstAttribute == .width }
        let height = group.constraints.first { $0.firstAttribute == .height }

        XCTAssertEqual(width?.constant, 100)
        XCTAssertEqual(height?.constant, 44)
    }
}