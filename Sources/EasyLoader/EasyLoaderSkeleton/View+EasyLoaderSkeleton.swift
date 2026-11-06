//
//  View+EasyLoaderSkeleton.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

public extension View {
    /// Shows this view as a shimmering skeleton while loading.
    ///
    /// Apply it once to a container and everything inside becomes a skeleton.
    /// Give the views placeholder data while loading, so they have a shape to show:
    /// ```swift
    /// ProfileCard(user: user ?? .placeholder)
    ///     .easyLoaderSkeleton(isLoading: user == nil)
    /// ```
    ///
    /// - Parameters:
    ///   - isLoading: Whether to show the skeleton.
    ///   - style: A style for this skeleton only. `nil` uses the style set with
    ///     `.easyLoaderSkeletonStyle(_:)`, or the defaults if none is set.
    func easyLoaderSkeleton(isLoading: Bool, style: SkeletonStyle? = nil) -> some View {
        modifier(SkeletonModifier(isLoading: isLoading, style: style))
    }
}
