//
//  View+EasyLoaderFull.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

public extension View {
    /// Shows a full-screen loader over this view.
    ///
    /// By default: white background and the standard system spinner.
    /// Apply it to the outermost view of a screen (e.g. the `NavigationStack`)
    /// so it covers the navigation bar too.
    ///
    /// ```swift
    /// NavigationStack { ... }
    ///     .easyLoaderFull(isPresented: isSaving, message: "Saving…")
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Whether the loader is visible.
    ///   - message: Optional text shown below the indicator.
    ///   - style: A style for this loader only. `nil` uses the style set with
    ///     `.easyLoaderFullStyle(_:)`, or the defaults if none is set.
    func easyLoaderFull(
        isPresented: Bool,
        message: String? = nil,
        style: LoaderStyle? = nil
    ) -> some View {
        modifier(FullScreenLoaderModifier(
            isPresented: isPresented,
            message: message,
            style: style,
            indicatorOverride: nil
        ))
    }

    /// Shows a full-screen loader with your own indicator for this loader only.
    ///
    /// ```swift
    /// .easyLoaderFull(isPresented: isLoading) {
    ///     MySpinner()
    /// }
    /// ```
    func easyLoaderFull<Indicator: View>(
        isPresented: Bool,
        message: String? = nil,
        style: LoaderStyle? = nil,
        @ViewBuilder indicator: () -> Indicator
    ) -> some View {
        modifier(FullScreenLoaderModifier(
            isPresented: isPresented,
            message: message,
            style: style,
            indicatorOverride: AnyView(indicator())
        ))
    }
}
