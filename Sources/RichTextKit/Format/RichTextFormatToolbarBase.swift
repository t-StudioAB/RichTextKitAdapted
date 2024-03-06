//
//  RichTextFormatToolbarBase.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/// This internal protocol is used to share code between the
/// two toolbars, which should eventually become one.
protocol RichTextFormatToolbarBase: View {

    var config: RichTextFormatToolbar.Configuration { get }
    var style: RichTextFormatToolbar.Style { get }
}

extension RichTextFormatToolbarBase {

    var hasColorPickers: Bool {
        let colors = config.colorPickers
        let disclosed = config.colorPickersDisclosed
        return !colors.isEmpty || !disclosed.isEmpty
    }
}

extension RichTextFormatToolbarBase {

    @ViewBuilder
    func alignmentPicker(
        value: Binding<RichTextAlignment>
    ) -> some View {
        if !config.alignments.isEmpty {
            RichTextAlignment.Picker(
                selection: value,
                values: config.alignments
            )
            .pickerStyle(.segmented)
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func colorPickers(
        for context: RichTextContext
    ) -> some View {
        if hasColorPickers {
            VStack(spacing: style.spacing) {
                colorPickers(
                    for: config.colorPickers,
                    context: context
                )
                colorPickersDisclosureGroup(
                    for: config.colorPickersDisclosed,
                    context: context
                )
            }
        }
    }

    @ViewBuilder
    func colorPickers(
        for colors: [RichTextColor],
        context: RichTextContext
    ) -> some View {
        if !colors.isEmpty {
            ForEach(colors) {
                colorPicker(for: $0, context: context)
            }
        }
    }

    @ViewBuilder
    func colorPickersDisclosureGroup(
        for colors: [RichTextColor],
        context: RichTextContext
    ) -> some View {
        if !colors.isEmpty {
            DisclosureGroup(RTKL10n.more.text) {
                colorPickers(
                    for: config.colorPickersDisclosed,
                    context: context
                )
            }
        }
    }

    func colorPicker(
        for color: RichTextColor,
        context: RichTextContext
    ) -> some View {
        RichTextColor.Picker(
            type: color,
            value: context.binding(for: color),
            quickColors: .quickPickerColors
        )
    }

    @ViewBuilder
    func fontPicker(
        value: Binding<String>
    ) -> some View {
        if config.fontPicker {
            RichTextFont.Picker(selection: value, fontSize: 12) .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func fontSizePicker(
        for context: RichTextContext
    ) -> some View {
        if config.fontSizePicker {
            RichTextFont.SizePickerStack(context: context)
                .buttonStyle(.plain)

        }
    }

    @ViewBuilder
    func indentButtons(
        for context: RichTextContext,
        greedy: Bool
    ) -> some View {
        if config.indentButtons {
            RichTextAction.ButtonGroup(
                context: context,
                actions: [.stepIndent(points: -30), .stepIndent(points: 30)],
                greedy: greedy
            ).buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func lineSpacingPicker(
        for context: RichTextContext
    ) -> some View {
        if config.lineSpacingPicker {
            RichTextLine.SpacingPickerStack(context: context)
                .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func styleToggleGroup(
        for context: RichTextContext
    ) -> some View {
        if !config.styles.isEmpty {
            RichTextStyle.ToggleGroup(
                context: context,
                styles: config.styles
            )
        }
    }

    @ViewBuilder
    func superscriptButtons(
        for context: RichTextContext,
        greedy: Bool
    ) -> some View {
        if config.superscriptButtons {
            RichTextAction.ButtonGroup(
                context: context,
                actions: [.stepSuperscript(steps: -1), .stepSuperscript(steps: 1)],
                greedy: greedy
            )
        }
    }
}
#endif
