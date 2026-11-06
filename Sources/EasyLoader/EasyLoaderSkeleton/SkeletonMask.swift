//
//  SkeletonMask.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// Chooses the right mask for the current state and animation.
///
/// Where the mask is solid the content shows fully; where it's faint the content fades.
struct SkeletonMask: View {
    let style: SkeletonStyle
    let isActive: Bool
    let reduceMotion: Bool

    private var effectiveAnimation: SkeletonAnimation {
        guard isActive else { return .none }
        if reduceMotion && style.animation == .shimmer { return .pulse }
        return style.animation
    }

    var body: some View {
        switch effectiveAnimation {
        case .none:
            // Fully solid: shows the content as-is.
            // Extended past the edges so shadows and other overflow aren't clipped.
            Color.black.padding(-200)

        case .shimmer:
            TimelineView(.animation) { context in
                ShimmerBand(style: style, phase: style.phase(at: context.date))
            }

        case .pulse:
            TimelineView(.animation) { context in
                Color.black.opacity(style.pulseOpacity(at: context.date))
            }
        }
    }
}

/// A faint mask with a solid, angled band that moves across it.
struct ShimmerBand: View {
    let style: SkeletonStyle
    let phase: Double

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let band = max(width * style.clampedBandWidth, 1)
            // Extra distance so the tilted band fully enters and leaves the view.
            let slant = abs(tan(style.angle.radians)) * height / 2
            let start = -band - slant
            let travel = width + (band + slant) * 2
            let dim = Color.black.opacity(style.clampedDimmedOpacity)

            ZStack {
                dim

                LinearGradient(
                    stops: [
                        .init(color: dim, location: 0),
                        .init(color: .black, location: 0.5),
                        .init(color: dim, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: band, height: height * 3)
                .rotationEffect(style.angle)
                .position(x: start + travel * phase, y: height / 2)
            }
        }
    }
}
