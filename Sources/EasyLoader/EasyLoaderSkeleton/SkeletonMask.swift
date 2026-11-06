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

/// A faint mask with a soft, angled band of light that moves across it.
struct ShimmerBand: View {
    let style: SkeletonStyle
    let phase: Double

    /// How strong the band is at a point across its width, from `0` at the edges to `1` in the middle.
    ///
    /// Follows a smooth curve, so the band has no visible edges or sharp centre line.
    static func bandStrength(at position: Double) -> Double {
        0.5 - 0.5 * cos(position * 2 * .pi)
    }

    private var bandStops: [Gradient.Stop] {
        let count = 16
        return (0...count).map { index in
            let position = Double(index) / Double(count)
            return .init(color: .black.opacity(Self.bandStrength(at: position)), location: position)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let band = max(width * style.clampedBandWidth, 1)
            // Extra distance so the tilted band fully enters and leaves the view.
            let slant = abs(tan(style.angle.radians)) * height / 2
            let start = -band / 2 - slant
            let travel = width + band + slant * 2

            ZStack {
                Color.black.opacity(style.clampedDimmedOpacity)

                LinearGradient(stops: bandStops, startPoint: .leading, endPoint: .trailing)
                .frame(width: band, height: height * 3)
                .rotationEffect(style.angle)
                .position(x: start + travel * phase, y: height / 2)
            }
        }
    }
}
