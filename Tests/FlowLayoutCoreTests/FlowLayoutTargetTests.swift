//
//  FlowLayoutTargetTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutCore

@MainActor
final class FlowLayoutTargetTests: XCTestCase {
    func test_uiView_prepareForFlowLayout_disablesAutoresizingMask() {
        let view = UIView()
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)

        view.prepareForFlowLayout()

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
    }

    func test_uiView_anchorsMatchNativeAnchors() {
        let view = UIView()

        XCTAssertTrue(view.flowTopAnchor.rawAnchor === view.topAnchor)
        XCTAssertTrue(view.flowBottomAnchor.rawAnchor === view.bottomAnchor)
        XCTAssertTrue(view.flowLeadingAnchor.rawAnchor === view.leadingAnchor)
        XCTAssertTrue(view.flowTrailingAnchor.rawAnchor === view.trailingAnchor)
        XCTAssertTrue(view.flowCenterXAnchor.rawAnchor === view.centerXAnchor)
        XCTAssertTrue(view.flowCenterYAnchor.rawAnchor === view.centerYAnchor)
        XCTAssertTrue(view.flowWidthAnchor.rawDimension === view.widthAnchor)
        XCTAssertTrue(view.flowHeightAnchor.rawDimension === view.heightAnchor)
    }

    func test_uiView_flowSuperview_returnsSuperview() {
        let parent = UIView()
        let child = UIView()
        parent.addSubview(child)

        XCTAssertTrue(child.flowSuperview === parent)
    }

    func test_uiView_flowSuperview_isNilWithoutParent() {
        let view = UIView()
        XCTAssertNil(view.flowSuperview)
    }

    func test_uiView_flowSafeArea_returnsSafeAreaLayoutGuide() {
        let view = UIView()
        XCTAssertTrue(view.flowSafeArea === view.safeAreaLayoutGuide)
    }

    func test_uiLayoutGuide_anchorsMatchNativeAnchors() {
        let view = UIView()
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)

        XCTAssertTrue(guide.flowTopAnchor.rawAnchor === guide.topAnchor)
        XCTAssertTrue(guide.flowLeadingAnchor.rawAnchor === guide.leadingAnchor)
        XCTAssertTrue(guide.flowWidthAnchor.rawDimension === guide.widthAnchor)
    }

    func test_uiLayoutGuide_flowSuperview_returnsOwningView() {
        let view = UIView()
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)

        XCTAssertTrue(guide.flowSuperview === view)
    }

    func test_uiLayoutGuide_prepareForFlowLayout_isNoOp() {
        let guide = UILayoutGuide()
        guide.prepareForFlowLayout() // should simply not crash
    }
}