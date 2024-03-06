//
//  FontRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/// This typealias bridges platform-specific fonts.
public typealias FontRepresentable = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/// This typealias bridges platform-specific fonts.
public typealias FontRepresentable = NSFont
#endif

public extension FontRepresentable {

    /// The standard font to use for rich text.
    static var standardRichTextFont = systemFont(ofSize: .standardRichTextFontSize)

    /// Create a new font by toggling a certain style.
    func toggling(
        _ style: RichTextStyle
    ) -> FontRepresentable? {
        .init(
            descriptor: fontDescriptor.byTogglingStyle(style),
            size: pointSize
        )
    }
}
