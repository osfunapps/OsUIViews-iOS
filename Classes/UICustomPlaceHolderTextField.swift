//
//  UICustomHintTextField.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 02/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// This is just a text field with a custom place holder color option and padding
@IBDesignable public class UICustomPlaceHolderTextField: UITextField {
    
    // indications
    private var viewPlaceHolder: String!
    
    /// Will inform if text exists or only place holder
    var placeHolderDisplays: Bool = false
    
    // indications
    var forwardDelegate: UITextFieldDelegate? = nil
    
    /// We override the delegate here so it may produce weird behaviour. Not all delegate functions forwarded to the delegate
    public override var delegate: UITextFieldDelegate? {
        didSet {
            if delegate is UICustomPlaceHolderTextField {
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
    
    /// set the normal color for the text here (not the color of the place holder)
    @IBInspectable public var textNormalColor: UIColor = .black {
        didSet {
            textColor = placeHolderColor
        }
    }
    
    /// set the place holder color for the text here (not the color of the normal text)
    @IBInspectable public var placeHolderColor: UIColor = .gray {
        didSet {
            textColor = placeHolderColor
        }
    }
    
    /// Used to inset the bounds of the text field. The x values is applied as horizontal insets and the y value is applied as vertical insets.
    @IBInspectable private var centerInset: CGPoint = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        delegate = self
        viewPlaceHolder = self.placeholder
        setPlaceHolder()
        placeholder = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped(recognizer:)))
        addGestureRecognizer(tapGesture)
        clearButtonMode = .never
        if addDoneButton {
            addDoneButton()
        }
    }
    
}

// MARK: - Hint
extension UICustomPlaceHolderTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString appended: String) -> Bool {
        var oldStr = self.text
        var newStr: String!
        
        if oldStr == nil {
            oldStr = ""
        }
        
        else if appended == "" {
            newStr = String(oldStr!.dropLast())
        } else {
            newStr = "\(oldStr!)\(appended)"
        }
        
        
        // if the user trying to delete the hint, set it again
        if tryingToDeleteHint(newStr) || isInputEmpty(newStr) {
            clearButtonMode = .never
            forwardDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: appended)
            setPlaceHolder()
            moveCaretToLineStart()
            return true
            
        // if the input starts with the hint, remove only the hint
        } else if(isStartsWithHint(newStr)) {
            self.text?.removeAll()
        }
        clearButtonMode = .whileEditing
        textColor = textNormalColor
        placeHolderDisplays = false
        forwardDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: appended)
        return true
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        setPlaceHolder()
        moveCaretToLineStart()
        self.clearButtonMode = .never
        forwardDelegate?.textFieldShouldClear?(self)
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let forwardDelegate = forwardDelegate,
           let res = forwardDelegate.textFieldShouldBeginEditing?(self) {
            return res
        }
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let forwardDelegate = forwardDelegate,
           let res = forwardDelegate.textFieldShouldEndEditing?(self) {
            return res
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        forwardDelegate?.textFieldDidEndEditing?(self)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        forwardDelegate?.textFieldDidBeginEditing?(self)
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
        return newStr != nil && newStr!.starts(with: viewPlaceHolder!)
    }
    
    
    private func tryingToDeleteHint(_ newStr: String) -> Bool {
        let halfHint: String = viewPlaceHolder![0...viewPlaceHolder!.count-2]
        return newStr == halfHint
    }
    
    private func clickedDelete(_ lastString: String?, _ newStr: String?) -> Bool {
        return (lastString != nil && newStr != nil) && (lastString!.count-1 == newStr!.count)
    }
    
    private func isInputEmpty(_ newStr: String?) -> Bool {
        return newStr == nil || newStr == ""
    }
    
    /// Will set the place holder and remove th text
    public func setPlaceHolder() {
        text = viewPlaceHolder
        textColor = placeHolderColor
        placeHolderDisplays = true
    }
    
}


// MARK: - Padding
extension UICustomPlaceHolderTextField {
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }
    
    private func insetTextRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.insetBy(dx: centerInset.x, dy: centerInset.y)
        return insetBounds
    }
    
}

