//  RichTextEditor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/**
 This SwiftUI editor can be used to view and edit rich text.

 The view uses a platform-specific `RichTextView together
 with a `RichTextContext and a RichTextCoordinator to
 make view and context changes sync correctly.

 You can use the provided context to trigger and observe any
 changes to the text editor. Note that changing the value of
 the text binding will not yet update the editor. Until it
 is fixed, use setAttributedString(to:).

 Since the view wraps a native UIKit or AppKit text view,
 you can't apply .toolbar modifiers to it, like you can do
 with other SwiftUI views. This means that this doesn't work:

 
swift
 RichTextEditor(text: $text, context: context)
     .toolbar {
         ToolbarItemGroup(placement: .keyboard) {
             ....
         }
     }


 This code will not show anything when you start to edit the
 text. To work around this use a `RichTextKeyboardToolbar.

 You may have noticed that updateUIView/updateNSView don't
 contain any code. This is because having updates there will
 update this view, which in turn makes typing very slow.
 */
public struct RichTextEditor: ViewRepresentable {
    private var font: NSFont?

    public init(
        text: Binding<NSAttributedString>,
        context: RichTextContext,
        config: RichTextView.Configuration = .standard,
        format: RichTextDataFormat = .archivedData,
        placeholder: NSAttributedString? = nil,  // Placeholder is an NSAttributedString
        font: NSFont? = nil,  // Optional font
        viewConfiguration: @escaping ViewConfiguration = { _ in }
    ) {
        self.text = text
        self.config = config
        self.placeholder = placeholder
        self.font = font  // Pass font separately if needed
        self._context = ObservedObject(wrappedValue: context)
        self.format = format
        self.viewConfiguration = viewConfiguration
    }

    public typealias ViewConfiguration = (RichTextViewComponent) -> Void

    @ObservedObject
    private var context: RichTextContext

    private var text: Binding<NSAttributedString>
    private let config: RichTextView.Configuration
    private var format: RichTextDataFormat
    private var viewConfiguration: ViewConfiguration
    private var placeholder: NSAttributedString?  // Store the placeholder
    
    #if iOS || os(tvOS) || os(visionOS)
    public let textView = RichTextView()
    #endif

    #if macOS
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.documentView as? RichTextView ?? RichTextView()
    }
    #endif

    public func makeCoordinator() -> RichTextCoordinator {
        RichTextCoordinator(
            text: text,
            textView: textView,
            richTextContext: context
        )
    }

    #if iOS || os(tvOS) || os(visionOS)
    public func makeUIView(context: Context) -> some UIView {
        textView.setup(with: text.wrappedValue, format: format)
        textView.configuration = config
        viewConfiguration(textView)
        return textView
    }

    public func updateUIView(_ view: UIViewType, context: Context) {
    }

    #else

    public func makeNSView(context: Context) -> some NSView {
        textView.setup(with: text.wrappedValue, format: format)
        textView.configuration = config

 // Use a plain string for the placeholder
    let plainPlaceholderString = placeholder?.string ?? ""
    textView.setValue(plainPlaceholderString, forKey: "placeholderString")

        viewConfiguration(textView)
        return scrollView
    }

 public func updateNSView(_ view: NSViewType, context: Context) {
        // Update the placeholder
        if let placeholder = placeholder {
            textView.setValue(placeholder, forKey: "placeholderAttributedString")
        }
        
        // Update the font
        if let font = font {
            textView.font = font
        }
        
        // Ensure the view redraws
        textView.needsDisplay = true
    }

    

    



    #endif
    
  
}


// MARK: RichTextPresenter

public extension RichTextEditor {

    /// Get the currently selected range.
    var selectedRange: NSRange {
        textView.selectedRange
    }
}

// MARK: RichTextReader

public extension RichTextEditor {

    /// Get the string that is managed by the editor.
    var attributedString: NSAttributedString {
        text.wrappedValue
    }
}

// MARK: RichTextWriter

public extension RichTextEditor {

    /// Get the mutable string that is managed by the editor.
    var mutableAttributedString: NSMutableAttributedString? {
        textView.mutableAttributedString
    }
}

#endif
