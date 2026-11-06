//
//  FullScreenLoaderModifier.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// Draws the full-screen overlay: background, indicator and optional message.
struct FullScreenLoaderModifier: ViewModifier {
    @Environment(\.loaderStyle) private var environmentStyle

    let isPresented: Bool
    let message: String?
    let style: LoaderStyle?
    /// An indicator passed directly on this call; it wins over the style's indicator.
    let indicatorOverride: AnyView?

    /// What VoiceOver reads: the message, or "Loading" if there's no text to read.
    var accessibilityMessage: String {
        guard let message, !message.isEmpty else { return "Loading" }
        return message
    }

    func body(content: Content) -> some View {
        // A per-call style wins; otherwise use the app-wide or section style.
        let resolved = style ?? environmentStyle

        content
            .overlay {
                if isPresented {
                    ZStack {
                        LoaderBackgroundView(background: resolved.background)
                            .opacity(resolved.clampedOpacity)

                        VStack(spacing: 12) {
                            if let indicatorOverride {
                                indicatorOverride
                            } else {
                                LoaderIndicatorView(indicator: resolved.indicator, style: resolved)
                            }

                            if let message, !message.isEmpty {
                                Text(message)
                                    .font(resolved.messageFont)
                                    .foregroundStyle(resolved.messageColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                        }
                    }
                    .contentShape(Rectangle())              // blocks taps to the content underneath
                    .ignoresSafeArea()                      // covers the status bar and home indicator areas
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(accessibilityMessage))
                    .accessibilityAddTraits(.isModal)       // VoiceOver stays on the loader
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}
