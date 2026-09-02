//
//  FlowLayoutDebuggerTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutDebug
import FlowLayoutDSL

@MainActor
final class FlowLayoutDebuggerTests: XCTestCase {
    func test_ambiguousViews_findsViewWithNoPositionConstraints() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let ambiguousView = UIView()
        container.addSubview(ambiguousView)
        ambiguousView.layout {
            $0.pinWidth(50)
            $0.pinHeight(50)
        }

        window.layoutIfNeeded()

        let found = FlowLayoutDebugger.ambiguousViews(in: window)
        XCTAssertTrue(found.contains(ambiguousView))
    }

    func test_ambiguousViews_isEmptyForFullyConstrainedView() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let wellConstrained = UIView()
        container.addSubview(wellConstrained)
        wellConstrained.layout { $0.pinEdges(to: .superview) }

        window.layoutIfNeeded()

        let found = FlowLayoutDebugger.ambiguousViews(in: window)
        XCTAssertFalse(found.contains(wellConstrained))
    }

    func test_diagnostic_reportsAffectingConstraintIdentifiers() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let subview = UIView()
        container.addSubview(subview)
        _ = subview.layout { $0.pinEdges(to: .superview) }

        window.layoutIfNeeded()

        let diagnostic = FlowLayoutDebugger.diagnostic(for: subview)
        XCTAssertFalse(diagnostic.isAmbiguous)
        XCTAssertEqual(diagnostic.affectingConstraintIdentifiers.count, 4)
        XCTAssertTrue(diagnostic.affectingConstraintIdentifiers.allSatisfy { $0.hasPrefix("FlowLayout:") })
    }

    func test_affectingConstraints_hasNoDuplicates() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let subview = UIView()
        container.addSubview(subview)
        _ = subview.layout {
            $0.pinCenter(to: .superview)
            $0.pinSize(CGSize(width: 40, height: 40))
        }

        window.layoutIfNeeded()

        let constraints = FlowLayoutDebugger.affectingConstraints(for: subview)
        let uniqueCount = Set(constraints.map(ObjectIdentifier.init)).count
        XCTAssertEqual(constraints.count, uniqueCount)
    }
}
