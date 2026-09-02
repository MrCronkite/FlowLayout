import XCTest
import UIKit
import FlowLayoutCore

final class LayoutPriorityTests: XCTestCase {
    func test_integerLiteral_setsRawValue() {
        let priority: LayoutPriority = 750
        XCTAssertEqual(priority.rawValue, 750)
    }

    func test_floatLiteral_setsRawValue() {
        let priority: LayoutPriority = 749.5
        XCTAssertEqual(priority.rawValue, 749.5)
    }

    func test_namedConstants_matchUIKitValues() {
        XCTAssertEqual(LayoutPriority.required.rawValue, UILayoutPriority.required.rawValue)
        XCTAssertEqual(LayoutPriority.high.rawValue, UILayoutPriority.defaultHigh.rawValue)
        XCTAssertEqual(LayoutPriority.low.rawValue, UILayoutPriority.defaultLow.rawValue)
        XCTAssertEqual(LayoutPriority.fittingSize.rawValue, UILayoutPriority.fittingSizeLevel.rawValue)
    }

    func test_uiKitValue_roundTrips() {
        let priority = LayoutPriority(600)
        XCTAssertEqual(priority.uiKitValue.rawValue, 600)
    }

    func test_comparable_ordersByRawValue() {
        XCTAssertTrue(LayoutPriority.low < LayoutPriority.high)
        XCTAssertTrue(LayoutPriority.high < LayoutPriority.required)
    }
}
