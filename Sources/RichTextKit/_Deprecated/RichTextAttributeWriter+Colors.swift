//
//  RichTextAttributeWriter+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use RichTextViewComponent instead.")
public extension RichTextAttributeWriter {

    /// Set a certain rich text color at a certain range.
    func setRichTextColorOld(
        _ color: RichTextColor,
        to val: ColorRepresentable,
        at range: NSRange
    ) {
        guard let attribute = color.attribute else { return }
        if richTextColorOld(color, at: range) == val { return }
        setRichTextAttribute(attribute, to: val, at: range)
    }
}
