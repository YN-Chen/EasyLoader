//
//  SkeletonStyleTests.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import XCTest
import SwiftUI
@testable import EasyLoader

@MainActor
final class SkeletonStyleTests: XCTestCase {
    func testDefaults() {
        let style = SkeletonStyle.default
        XCTAssertEqual(style.animation, .shimmer)
        XCTAssertEqual(style.duration, 1.5)
        XCTAssertEqual(style.angle, .degrees(20))
        XCTAssertEqual(style.bandWidth, 0.3)
        XCTAssertEqual(style.dimmedOpacity, 0.4)
    }

    func testPhaseComesFromTheClock() {
        let style = SkeletonStyle(duration: 1.5)
        let date = Date(timeIntervalSinceReferenceDate: 0.75)
        XCTAssertEqual(style.phase(at: date), 0.5, accuracy: 0.0001)
    }

    func testSeparateSkeletonsAreInSync() {
        let date = Date(timeIntervalSinceReferenceDate: 123.4)
        let first = SkeletonStyle(duration: 1.5).phase(at: date)
        let second = SkeletonStyle(duration: 1.5).phase(at: date)
        XCTAssertEqual(first, second)
    }

    func testPhaseWrapsAround() {
        let style = SkeletonStyle(duration: 1.5)
        let date = Date(timeIntervalSinceReferenceDate: 1.5 * 10 + 0.3)
        XCTAssertEqual(style.phase(at: date), 0.2, accuracy: 0.0001)
    }

    func testPulseGoesFromFullToDimmed() {
        let style = SkeletonStyle(duration: 1.5, dimmedOpacity: 0.4)
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let halfway = Date(timeIntervalSinceReferenceDate: 0.75)
        XCTAssertEqual(style.pulseOpacity(at: start), 1, accuracy: 0.0001)
        XCTAssertEqual(style.pulseOpacity(at: halfway), 0.4, accuracy: 0.0001)
    }

    func testValuesAreClamped() {
        let style = SkeletonStyle(duration: 0, bandWidth: 5, dimmedOpacity: -1)
        XCTAssertEqual(style.clampedDuration, 0.1)
        XCTAssertEqual(style.clampedBandWidth, 1)
        XCTAssertEqual(style.clampedDimmedOpacity, 0)
    }
}
