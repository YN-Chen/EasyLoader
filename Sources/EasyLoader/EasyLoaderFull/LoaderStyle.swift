//
//  LoaderStyle.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// The appearance of a full-screen loader.
///
/// Every property has a default, so you only set what you want to change:
/// ```swift
/// LoaderStyle(background: .color(.black), backgroundOpacity: 0.5)
/// ```
public struct LoaderStyle {
    /// What fills the screen behind the indicator. Default: `.color(.white)`.
    public var background: LoaderBackground
    /// Background opacity from `0` (fully transparent) to `1` (solid). Default: `1`.
    public var backgroundOpacity: Double
    /// What is shown in the middle of the screen. Default: `.system` (the standard spinner).
    public var indicator: LoaderIndicator
    /// Tint for the system spinner and SF Symbols. `nil` uses the system colour.
    /// Images and custom views keep their own colours.
    public var indicatorTint: Color?
    /// Size of the system spinner, SF Symbols and images. Default: `.large`.
    /// Custom views control their own size.
    public var indicatorSize: ControlSize
    /// Colour of the optional message text. Default: `.gray`.
    public var messageColor: Color
    /// Font of the optional message text. Default: `.callout`.
    public var messageFont: Font

    public init(
        background: LoaderBackground = .color(.white),
        backgroundOpacity: Double = 1.0,
        indicator: LoaderIndicator = .system,
        indicatorTint: Color? = nil,
        indicatorSize: ControlSize = .large,
        messageColor: Color = .gray,
        messageFont: Font = .callout
    ) {
        self.background = background
        self.backgroundOpacity = backgroundOpacity
        self.indicator = indicator
        self.indicatorTint = indicatorTint
        self.indicatorSize = indicatorSize
        self.messageColor = messageColor
        self.messageFont = messageFont
    }

    /// White, fully opaque background with the standard system spinner.
    public static var `default`: LoaderStyle { LoaderStyle() }

    /// Opacity kept between 0 and 1, even if a caller sets something out of range.
    var clampedOpacity: Double { min(max(backgroundOpacity, 0), 1) }
}
