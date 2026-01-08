//
//  NoPasteTextEditor.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import UIKit

struct NoPasteTextEditor: UIViewRepresentable {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        // Sync focus state
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: NoPasteTextEditor
        
        init(_ parent: NoPasteTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
        
        // Disable paste by overriding canPerformAction
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Check if this is a paste operation (text length > 1 usually indicates paste)
            // But we want to allow normal typing, so we check if the replacement text is longer than what would be normal typing
            // Actually, a better approach is to override canPerformAction in a custom UITextView subclass
            return true
        }
    }
}

// Custom UITextView that disables paste
class NoPasteTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable paste, cut, and copy operations
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        // Allow other actions like select, selectAll, etc.
        return super.canPerformAction(action, withSender: sender)
    }
}

struct NoPasteTextEditorV2: UIViewRepresentable {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    func makeUIView(context: Context) -> NoPasteTextView {
        let textView = NoPasteTextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = .clear
        textView.textColor = UIColor(hex: "E4E4E4")
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    func updateUIView(_ uiView: NoPasteTextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        // Sync focus state
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: NoPasteTextEditorV2
        
        init(_ parent: NoPasteTextEditorV2) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
    }
}
