//
//  LoaderIndicator.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// How an SF Symbol or image indicator moves.
public enum LoaderAnimation {
    /// Spins continuously.
    case rotate
    /// Gently fades in and out. SF Symbols use Apple's native pulse effect.
    case pulse
    /// Doesn't move.
    case none
}

/// What is shown in the middle of the loader.
public enum LoaderIndicator {
    /// The standard system spinner.
    case system
    /// An SF Symbol, e.g. `"arrow.triangle.2.circlepath"`.
    case symbol(String, animation: LoaderAnimation = .rotate)
    /// An image from your asset catalog (PNG, PDF or SVG).
    case image(Image, animation: LoaderAnimation = .rotate)
    /// Any view. Create with `.custom { }`.
    case view(AnyView)

    /// Your own indicator view, for example a custom spinner or a Lottie animation.
    ///
    /// ```swift
    /// .custom { MySpinner() }
    /// ```
    public static func custom<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> LoaderIndicator {
        .view(AnyView(content()))
    }
}

extension ControlSize {
    /// Point size used for SF Symbol indicators.
    var indicatorPointSize: CGFloat {
        switch self {
        case .mini: 16
        case .small: 22
        case .regular: 30
        case .large: 40
        default: 52   // .extraLarge and any future sizes
        }
    }
}

/// Draws a `LoaderIndicator` using the size and tint from a `LoaderStyle`.
struct LoaderIndicatorView: View {
    let indicator: LoaderIndicator
    let style: LoaderStyle

    private var imageSide: CGFloat { style.indicatorSize.indicatorPointSize * 1.5 }

    var body: some View {
        switch indicator {
        case .system:
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(style.indicatorSize)
                .tint(style.indicatorTint)

        case .symbol(let name, let animation):
            let symbol = Image(systemName: name)
                .font(.system(size: style.indicatorSize.indicatorPointSize, weight: .medium))
                .foregroundStyle(style.indicatorTint ?? .gray)

            if animation == .pulse {
                // Apple's native pulse (iOS 17+); handles Reduce Motion itself.
                symbol.symbolEffect(.pulse)
            } else {
                // Rotation needs iOS 18 as a symbol effect, so it's done manually.
                AnimatedIndicator(animation: animation) { symbol }
            }

        case .image(let image, let animation):
            AnimatedIndicator(animation: animation) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSide, height: imageSide)
            }

        case .view(let view):
            view
        }
    }
}

/// Applies a repeating rotate or pulse animation to its content.
///
/// With Reduce Motion turned on, spinning and scaling are replaced by a gentle fade.
struct AnimatedIndicator<Content: View>: View {
    let animation: LoaderAnimation
    @ViewBuilder let content: Content

    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var rotates: Bool { animation == .rotate && !reduceMotion }
    private var scales: Bool { animation == .pulse && !reduceMotion }
    private var fades: Bool { animation == .pulse || (animation == .rotate && reduceMotion) }

    private var repeatingAnimation: Animation? {
        if rotates { return .linear(duration: 1).repeatForever(autoreverses: false) }
        if scales || fades { return .easeInOut(duration: 0.8).repeatForever(autoreverses: true) }
        return nil
    }

    var body: some View {
        content
            .rotationEffect(.degrees(rotates && isAnimating ? 360 : 0))
            .scaleEffect(scales && isAnimating ? 0.85 : 1)
            .opacity(fades && isAnimating ? 0.5 : 1)
            // Attached locally so it only animates these effects,
            // not the loader's fade-in/out.
            .animation(repeatingAnimation, value: isAnimating)
            .onAppear { isAnimating = true }
    }
}
