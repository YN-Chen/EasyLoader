//
//  SkeletonEnvironment.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    // Internal: users set this through .easyLoaderSkeletonStyle(...)
    @Entry var skeletonStyle: SkeletonStyle = .default
}

public extension View {
    /// Sets the skeleton style for this view and everything inside it.
    ///
    /// Apply at the root of your app for an app-wide style, or further down
    /// to override it for one section. The nearest style wins.
    ///
    /// ```swift
    /// ContentView()
    ///     .easyLoaderSkeletonStyle(SkeletonStyle(duration: 2))
    /// ```
    func easyLoaderSkeletonStyle(_ style: SkeletonStyle) -> some View {
        environment(\.skeletonStyle, style)
    }

    /// Changes only some properties of the inherited skeleton style.
    ///
    /// ```swift
    /// FeedView()
    ///     .easyLoaderSkeletonStyle { $0.angle = .degrees(0) }
    /// ```
    func easyLoaderSkeletonStyle(_ transform: @escaping (inout SkeletonStyle) -> Void) -> some View {
        transformEnvironment(\.skeletonStyle, transform: transform)
    }
}
