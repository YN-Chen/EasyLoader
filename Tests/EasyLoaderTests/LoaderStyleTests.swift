//
//  LoaderStyleTests.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import XCTest
import SwiftUI
@testable import EasyLoader

@MainActor
final class LoaderStyleTests: XCTestCase {
    func testDefaults() {
        let style = LoaderStyle.default

        guard case .system = style.background else {
            return XCTFail("Default background should be the system background")
        }

        guard case .system = style.indicator else {
            return XCTFail("Default indicator should be the system spinner")
        }

        XCTAssertEqual(style.backgroundOpacity, 1.0)
        XCTAssertNil(style.indicatorTint)
        XCTAssertEqual(style.indicatorSize, .large)
        XCTAssertEqual(style.messageColor, .gray)
        XCTAssertEqual(style.messageFont, .callout)
    }

    func testCustomValuesOverrideDefaults() {
        let style = LoaderStyle(background: .color(.black), backgroundOpacity: 0.5)

        guard case .color(let color) = style.background else {
            return XCTFail("Background should be a colour")
        }
        XCTAssertEqual(color, .black)
        XCTAssertEqual(style.backgroundOpacity, 0.5)
        XCTAssertEqual(style.indicatorSize, .large)   // untouched values keep their defaults
    }

    func testImageBackgroundDefaultsToFill() {
        let style = LoaderStyle(background: .image(Image(systemName: "star")))

        guard case .image(_, let contentMode) = style.background else {
            return XCTFail("Background should be an image")
        }
        XCTAssertEqual(contentMode, .fill)
    }

    func testSymbolIndicatorDefaultsToRotate() {
        let style = LoaderStyle(indicator: .symbol("hourglass"))

        guard case .symbol(let name, let animation) = style.indicator else {
            return XCTFail("Indicator should be a symbol")
        }
        XCTAssertEqual(name, "hourglass")
        XCTAssertEqual(animation, .rotate)
    }

    func testIndicatorSizesGetBigger() {
        let sizes: [ControlSize] = [.mini, .small, .regular, .large]
        let points = sizes.map(\.indicatorPointSize)
        XCTAssertEqual(points, points.sorted())
    }

    func testVoiceOverFallsBackToLoading() {
        func spokenText(for message: String?) -> String {
            FullScreenLoaderModifier(
                isPresented: true,
                message: message,
                style: nil,
                indicatorOverride: nil
            ).accessibilityMessage
        }

        XCTAssertEqual(spokenText(for: "Saving…"), "Saving…")
        XCTAssertEqual(spokenText(for: nil), "Loading")
        XCTAssertEqual(spokenText(for: ""), "Loading")
    }

    func testOpacityIsClamped() {
        XCTAssertEqual(LoaderStyle(backgroundOpacity: 1.5).clampedOpacity, 1)
        XCTAssertEqual(LoaderStyle(backgroundOpacity: -0.2).clampedOpacity, 0)
        XCTAssertEqual(LoaderStyle(backgroundOpacity: 0.4).clampedOpacity, 0.4)
    }
}
