//
//  RichTextFont+SizePicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This picker can be used to pick a font size.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.
     */
    struct SizePicker: View {

        /**
         Create a font size picker.

         - Parameters:
           - selection: The selected font size.
           - values: The values to display in the list.
         */
        public init(
            selection: Binding<CGFloat>,
            values: [CGFloat] = standardValues
        ) {
            self._selection = selection
            self.values = Self.values(
                for: values,
                selection: selection.wrappedValue
            )
        }

        private let values: [CGFloat]

        @Binding
        private var selection: CGFloat

        public var body: some View {
            SwiftUI.Picker("", selection: $selection) {
                ForEach(values, id: \.self) {
                    text(for: $0)
                        .tag($0)
                }
            }
            .labelsHidden()
            .accessibilityLabel(RTKL10n.fontSize.text)
        }
    }
}

public extension RichTextFont.SizePicker {

    /// The standard picker values.
    static var standardValues: [CGFloat] {
        [10, 12, 14, 18, 20, 22, 24, 28, 36, 48, 64, 72, 96, 144]
    }

    /// Get a list of values for a certain selection.
    static func values(
        for values: [CGFloat],
        selection: CGFloat
    ) -> [CGFloat] {
        let values = values + [selection]
        return Array(Set(values)).sorted()
    }
}

private extension RichTextFont.SizePicker {

    func text(
        for fontSize: CGFloat
    ) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct RichTextFont_SizePicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 36.0

        var body: some View {
            List {
                HStack {
                    RichTextFont.SizePicker(
                        selection: $selection
                    )
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
