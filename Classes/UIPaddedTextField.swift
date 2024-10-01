//
//  PaddedUITextField.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/// A UITextField subclass that adds customizable padding to the text and placeholder.
open class UIPaddedTextField: UITextField {
    
    
    /// Padding to apply to the text field, customizable via Interface Builder.
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // MARK: - Padding Customization via Interface Builder
    
    @IBInspectable var startPadding: CGFloat = 0.0 {
        didSet {
            padding.left = startPadding
        }
    }
    
    @IBInspectable var endPadding: CGFloat = 0.0 {
        didSet {
            padding.right = endPadding
        }
    }
    
    @IBInspectable var topPadding: CGFloat = 0.0 {
        didSet {
            padding.top = topPadding
        }
    }
    
    @IBInspectable var bottomPadding: CGFloat = 0.0 {
        didSet {
            padding.bottom = bottomPadding
        }
    }
    
    // MARK: - Overriding UITextField Methods for Padding
    
    /// Adjusts the text rectangle based on padding values.
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /// Adjusts the placeholder rectangle based on padding values.
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /// Adjusts the editing text rectangle based on padding values.
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
