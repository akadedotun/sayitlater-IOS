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
            // Only update if text actually changed to prevent unnecessary re-renders
            if parent.text != textView.text {
                parent.text = textView.text
            }
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
        context.coordinator.textView = textView
        context.coordinator.parentIsFocused = isFocused
        return textView
    }
    
    func updateUIView(_ uiView: NoPasteTextView, context: Context) {
        let isFirstResponder = uiView.isFirstResponder
        let coordinatorIsEditing = context.coordinator.isEditing
        let isEditing = isFirstResponder || coordinatorIsEditing
        
        // CRITICAL: Never update text while user is editing - this causes keyboard to dismiss
        // BUT: If text becomes empty, force update to clear the field
        // This handles the case where draft is cleared after submission
        if text.isEmpty && !uiView.text.isEmpty {
            // Force clear when text becomes empty (e.g., after saving)
            // Clear immediately if not editing, or use async if editing to avoid keyboard dismissal
            if !isEditing {
                uiView.text = ""
            } else {
                // If editing, clear after a brief delay to avoid interrupting typing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak uiView] in
                    if let textView = uiView, self.text.isEmpty {
                        textView.text = ""
                    }
                }
            }
        } else if !isEditing && uiView.text != text {
            uiView.text = text
        }
        
        // Store the desired focus state but don't act on it if we're currently editing
        // This breaks the cycle by preventing focus changes during active editing
        context.coordinator.parentIsFocused = isFocused
        
        // Only sync focus state if NOT currently editing - prevents AttributeGraph cycles
        // Also don't force focus if user is already typing (text is not empty)
        if !isEditing {
            if isFocused && !isFirstResponder && text.isEmpty {
                // Only auto-focus if text is empty (initial state)
                uiView.becomeFirstResponder()
            } else if !isFocused && isFirstResponder {
                uiView.resignFirstResponder()
            }
        }
        // If editing, completely ignore focus state changes - prevents cycle
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: NoPasteTextEditorV2
        weak var textView: UITextView?
        var isEditing = false
        var parentIsFocused = false // Track parent's desired focus state
        
        init(_ parent: NoPasteTextEditorV2) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let newText = textView.text ?? ""
            
            // Update binding immediately - the focus state protection in updateUIView prevents cycles
            // Only update if text actually changed to prevent unnecessary updates
            if parent.text != newText {
                parent.text = newText
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            isEditing = true
            // Use async dispatch to break the AttributeGraph cycle
            // Only update if state actually changed
            if !parent.isFocused {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if !self.parent.isFocused {
                        self.parent.isFocused = true
                        self.parentIsFocused = true
                    }
                }
            } else {
                parentIsFocused = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            isEditing = false
            // Use async dispatch to break the AttributeGraph cycle
            // Only update if state actually changed
            if parent.isFocused {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if self.parent.isFocused {
                        self.parent.isFocused = false
                        self.parentIsFocused = false
                    }
                }
            } else {
                parentIsFocused = false
            }
            // Sync text when editing ends in case there were external changes
            // Also clear if parent text is empty
            if let textView = self.textView {
                if parent.text.isEmpty {
                    textView.text = ""
                } else if textView.text != parent.text {
                    textView.text = parent.text
                }
            }
        }
    }
}
