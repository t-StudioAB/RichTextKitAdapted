//
//  RichTextFormatToolbar+Style.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormatToolbar {

    /// This struct can be used to style a format sheet.
    struct Style {

        public init(
            padding: Double = 10,
            spacing: Double = 10
        ) {
            self.padding = padding
            self.spacing = spacing
        }

        public var padding: Double
        public var spacing: Double
    }

    /// This environment key defines a format toolbar style.
    struct StyleKey: EnvironmentKey {

        public static let defaultValue = RichTextFormatToolbar.Style()
    }
}

public extension View {

    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarStyle(
        _ style: RichTextFormatToolbar.Style
    ) -> some View {
        self.environment(\.richTextFormatToolbarStyle, style)
    }
}

public extension EnvironmentValues {

    /// This environment value defines format toolbar styles.
    var richTextFormatToolbarStyle: RichTextFormatToolbar.Style {
        get { self [RichTextFormatToolbar.StyleKey.self] }
        set { self [RichTextFormatToolbar.StyleKey.self] = newValue }
    }
}
#endif
