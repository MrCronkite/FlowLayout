//
//  LayoutRelationTests.swift
//  FlowLayout
//
//  Created by Влад Шимченко on 02.09.2026.
//


import XCTest
import UIKit
import FlowLayoutCore

final class LayoutRelationTests: XCTestCase {
    func test_equal_mapsToNSLayoutConstraintEqual() {
        XCTAssertEqual(LayoutRelation.equal.uiKitValue, .equal)
    }

    func test_greaterThanOrEqual_mapsCorrectly() {
        XCTAssertEqual(LayoutRelation.greaterThanOrEqual.uiKitValue, .greaterThanOrEqual)
    }

    func test_lessThanOrEqual_mapsCorrectly() {
        XCTAssertEqual(LayoutRelation.lessThanOrEqual.uiKitValue, .lessThanOrEqual)
    }
}