//
//  LoaderBackground.swift
//  EasyLoader
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI

/// What fills the screen behind the loader's indicator.
public enum LoaderBackground {
    /// The system background. Follows light and dark mode automatically.
    case system
    /// A solid colour.
    case color(Color)
    /// An image. `.fill` covers the screen (cropping if needed); `.fit` shows the whole image.
    case image(Image, contentMode: ContentMode = .fill)
    /// A system blur material, e.g. `.ultraThinMaterial`.
    case material(Material)
    /// Any view. Create with `.custom { }`.
    case view(AnyView)

    /// Any view as the background, for example a gradient.
    ///
    /// ```swift
    /// .custom {
    ///     LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)
    /// }
    /// ```
    public static func custom<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> LoaderBackground {
        .view(AnyView(content()))
    }
}

/// Draws a `LoaderBackground` so it fills the available space.
struct LoaderBackgroundView: View {
    let background: LoaderBackground

    var body: some View {
        switch background {
        case .system:
            Rectangle().fill(.background)
        case .color(let color):
            color
        case .image(let image, let contentMode):
            // Color.clear sets the size; the image fills it and is clipped,
            // so a large image can't push the layout off-screen.
            Color.clear
                .overlay {
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                }
                .clipped()
        case .material(let material):
            Rectangle().fill(material)
        case .view(let view):
            view
        }
    }
}
