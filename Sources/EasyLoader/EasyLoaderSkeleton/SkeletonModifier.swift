//
//  SkeletonModifier.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// Turns content into a shimmering skeleton while loading.
struct SkeletonModifier: ViewModifier {
    @Environment(\.skeletonStyle) private var environmentStyle
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let isLoading: Bool
    let style: SkeletonStyle?

    func body(content: Content) -> some View {
        // A per-call style wins; otherwise use the app-wide or section style.
        let resolved = style ?? environmentStyle

        // Every modifier is always applied; only its values change.
        // Wrapping the content in if/else would make SwiftUI treat it as a new
        // view when loading finishes, resetting the user's @State and
        // re-running their onAppear/.task.
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .mask {
                SkeletonMask(style: resolved, isActive: isLoading, reduceMotion: reduceMotion)
            }
            .allowsHitTesting(!isLoading)       // no tapping fake buttons or rows
            .accessibilityHidden(isLoading)     // VoiceOver skips the fake content...
            .overlay {
                if isLoading {
                    Color.clear                 // ...and says "Loading" once instead
                        .accessibilityElement()
                        .accessibilityLabel(Text("Loading"))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isLoading)
    }
}
