//
//  CrossAttributeTargetTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutDSL

@MainActor
final class CrossAttributeTargetTests: XCTestCase {
    func test_pinTop_toBottomOfAnotherView() {
        let container = UIView()
        let icon = UIView()
        let label = UIView()
        container.addSubview(icon)
        container.addSubview(label)

        let group = label.layout { $0.pinTop(to: .bottom(of: icon), inset: 8) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.firstAnchor === label.topAnchor)
        XCTAssertTrue(constraint.secondAnchor === icon.bottomAnchor)
        XCTAssertEqual(constraint.constant, 8)
    }

    func test_pinLeading_toTrailingOfAnotherView() {
        let container = UIView()
        let icon = UIView()
        let label = UIView()
        container.addSubview(icon)
        container.addSubview(label)

        let group = label.layout { $0.pinLeading(to: .trailing(of: icon), inset: 4) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.secondAnchor === icon.trailingAnchor)
        XCTAssertEqual(constraint.constant, 4)
    }

    func test_pinCenterY_toCenterYOfAnotherView() {
        let container = UIView()
        let a = UIView()
        let b = UIView()
        container.addSubview(a)
        container.addSubview(b)

        let group = b.layout { $0.pinCenterY(to: .centerY(of: a)) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.secondAnchor === a.centerYAnchor)
    }

    func test_pinTop_toViewOf_usesSameAttribute() {
        // .view(_:) means "same edge as the one being pinned" — top-to-top here.
        let a = UIView()
        let b = UIView()

        let group = b.layout { $0.pinTop(to: .view(a)) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.secondAnchor === a.topAnchor)
    }

    func test_pinLeading_toGuide() {
        let container = UIView()
        let guide = UILayoutGuide()
        container.addLayoutGuide(guide)
        let subview = UIView()
        container.addSubview(subview)

        let group = subview.layout { $0.pinLeading(to: .guide(guide)) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.secondAnchor === guide.leadingAnchor)
    }

    func test_pinTop_toSafeArea() {
        let container = UIView()
        let subview = UIView()
        container.addSubview(subview)

        let group = subview.layout { $0.pinTop(to: .safeArea, inset: 20) }
        let constraint = try! XCTUnwrap(group.constraints.first)

        XCTAssertTrue(constraint.secondAnchor === container.safeAreaLayoutGuide.topAnchor)
        XCTAssertEqual(constraint.constant, 20)
    }
}