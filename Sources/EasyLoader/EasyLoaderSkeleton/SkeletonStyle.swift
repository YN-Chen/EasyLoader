//
//  SkeletonStyle.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// How a skeleton moves while loading.
public enum SkeletonAnimation {
    /// A band of light sweeps across the placeholders.
    case shimmer
    /// The placeholders gently fade in and out.
    case pulse
    /// Static placeholders, no movement.
    case none
}

/// The appearance of a skeleton loading state.
///
/// Every property has a default, so you only set what you want to change:
/// ```swift
/// SkeletonStyle(duration: 2, angle: .degrees(0))
/// ```
public struct SkeletonStyle {
    /// Default: `.shimmer`. With Reduce Motion on, `.shimmer` becomes `.pulse` automatically.
    public var animation: SkeletonAnimation
    /// Seconds for one sweep (or one pulse). Default: `1.5`.
    public var duration: Double
    /// Tilt of the shimmer band. Default: `20°`.
    public var angle: Angle
    /// Width of the band as a fraction of the view's width, from `0.05` to `1`. Default: `0.3`.
    public var bandWidth: Double
    /// How faint the placeholders are outside the band, from `0` to `1`. Default: `0.4`.
    public var dimmedOpacity: Double

    public init(
        animation: SkeletonAnimation = .shimmer,
        duration: Double = 1.5,
        angle: Angle = .degrees(20),
        bandWidth: Double = 0.3,
        dimmedOpacity: Double = 0.4
    ) {
        self.animation = animation
        self.duration = duration
        self.angle = angle
        self.bandWidth = bandWidth
        self.dimmedOpacity = dimmedOpacity
    }

    /// Shimmer, 1.5 seconds per sweep, tilted 20°.
    public static var `default`: SkeletonStyle { SkeletonStyle() }

    // MARK: - Internal

    var clampedDuration: Double { max(duration, 0.1) }
    var clampedBandWidth: Double { min(max(bandWidth, 0.05), 1) }
    var clampedDimmedOpacity: Double { min(max(dimmedOpacity, 0), 1) }

    /// Progress through the current cycle, from 0 up to (not including) 1.
    ///
    /// Calculated from the clock rather than from when a view appeared, so every
    /// skeleton on screen is at the same point in the animation, even ones that
    /// appeared later.
    func phase(at date: Date) -> Double {
        let time = date.timeIntervalSinceReferenceDate
        return time.truncatingRemainder(dividingBy: clampedDuration) / clampedDuration
    }

    /// Opacity for the pulse animation: 1 at the start of a cycle,
    /// down to `dimmedOpacity` halfway, back to 1.
    func pulseOpacity(at date: Date) -> Double {
        let wave = 0.5 + 0.5 * cos(phase(at: date) * 2 * .pi)
        let low = clampedDimmedOpacity
        return low + (1 - low) * wave
    }
}
