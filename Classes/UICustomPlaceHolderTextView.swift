//
//  UICustomHintTextField.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 02/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// This is just a text view with a custom place holder color option and padding
@IBDesignable public class UICustomPlaceHolderTextView: UITextView {
    
    /// Will inform if text exists or only place holder
    public var placeHolderDisplays: Bool = false
    
    // indications
    private var forwardDelegate: UITextViewDelegate? = nil
    
    
    /// We override the delegate here so it may produce weird behaviour. Not all delegate functions forwarded to the delegate
    public override var delegate: UITextViewDelegate? {
        didSet {
            if delegate is UICustomPlaceHolderTextView {
                return
            }
            forwardDelegate = delegate
            if delegate != nil {
                delegate = self
            }
        }
    }
    
    /// Toggle to add a done button to the pop up keyboard to close it
    @IBInspectable public var addDoneButton: Bool = true {
        didSet {
            if addDoneButton {
                addDoneButton()
            }
        }
    }
    
    /// Set your place holder text here
    @IBInspectable public var placeHolder: String = "" {
        didSet {
            setHint()
        }
    }
    
    @IBInspectable public var textNormalColor: UIColor = .black {
        didSet {
            textColor = placeHolderColor
        }
    }
    
    @IBInspectable public var placeHolderColor: UIColor = .gray {
        didSet {
            textColor = placeHolderColor
        }
    }
    
    /// Used to inset the bounds of the text field. The x values is applied as horizontal insets and the y value is applied as vertical insets.
    @IBInspectable private var centerInset: CGPoint = .zero {
        didSet {
            contentInset = UIEdgeInsets(top: centerInset.y,
                                        left: centerInset.x,
                                        bottom: -centerInset.y,
                                        right: -centerInset.x)
            setNeedsLayout()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped(recognizer:)))
        addGestureRecognizer(tapGesture)
        delegate = self
        if addDoneButton {
            addDoneButton()
        }
    }
    
}

// MARK: - Hint
extension UICustomPlaceHolderTextView: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        forwardDelegate?.textViewDidChange?(textView)
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        forwardDelegate?.textViewDidChange?(textView)
//    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var oldStr = self.text
        var newStr: String!
        
        if oldStr == nil {
            oldStr = ""
        }
        
        else if text == "" {
            newStr = String(oldStr!.dropLast())
        } else {
            newStr = "\(oldStr!)\(text)"
        }
        
        
        // if the user trying to delete the hint, set it again
        if tryingToDeleteHint(newStr) || isInputEmpty(newStr) {
            setHint()
            moveCaretToLineStart()
            let returnValue = forwardDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: newStr)
            forwardDelegate?.textViewDidChange?(textView)
            return returnValue ?? true
            
        // if the input starts with the hint, remove only the hint
        } else if(isStartsWithHint(newStr)) {
            self.text?.removeAll()
        }
        placeHolderDisplays = false
        textColor = textNormalColor
        
        let returnValue = forwardDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: newStr)
        return returnValue ?? true
    }
    
    
    @objc func textViewTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            self.becomeFirstResponder()
            if textColor == placeHolderColor {
                self.moveCaretToLineStart()
            }
        }
    }
    
    private func isStartsWithHint(_ newStr: String?) -> Bool {
        return newStr != nil && newStr!.starts(with: placeHolder)
    }
    
    
    private func tryingToDeleteHint(_ newStr: String) -> Bool {
        let halfHint: String = placeHolder[0...placeHolder.count-2]
        return newStr == halfHint
    }
    
    private func clickedDelete(_ lastString: String?, _ newStr: String?) -> Bool {
        return (lastString != nil && newStr != nil) && (lastString!.count-1 == newStr!.count)
    }
    
    private func isInputEmpty(_ newStr: String?) -> Bool {
        return newStr == nil || newStr == ""
    }
    
    private func setHint() {
        text = placeHolder
        textColor = placeHolderColor
        placeHolderDisplays = true
    }
}
