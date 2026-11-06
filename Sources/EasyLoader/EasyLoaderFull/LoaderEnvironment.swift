//
//  LoaderEnvironment.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    // Internal: users set this through .easyLoaderFullStyle(...)
    @Entry var loaderStyle: LoaderStyle = .default
}

public extension View {
    /// Sets the full-screen loader style for this view and everything inside it.
    ///
    /// Apply at the root of your app for an app-wide style, or further down
    /// to override it for one section. The nearest style wins.
    ///
    /// ```swift
    /// ContentView()
    ///     .easyLoaderFullStyle(LoaderStyle(background: .color(.black), backgroundOpacity: 0.6))
    /// ```
    func easyLoaderFullStyle(_ style: LoaderStyle) -> some View {
        environment(\.loaderStyle, style)
    }

    /// Changes only some properties of the inherited full-screen loader style.
    ///
    /// ```swift
    /// CheckoutView()
    ///     .easyLoaderFullStyle { $0.backgroundOpacity = 0.3 }
    /// ```
    func easyLoaderFullStyle(_ transform: @escaping (inout LoaderStyle) -> Void) -> some View {
        transformEnvironment(\.loaderStyle, transform: transform)
    }
}
