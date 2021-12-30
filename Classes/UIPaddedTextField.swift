//
//  PaddedUITextField.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/// Just a text field with padding
class UIPaddedTextField: UITextField {
    
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 0,
                                             left: 0,
                                             bottom: 0,
                                             right: 0)
    
    @IBInspectable var startPadding: CGFloat = 0.0 {
        didSet {
            updatePadding()
        }
    }
    
    private func updatePadding() {
        
    }
    
    @IBInspectable var endPadding: CGFloat = 0.0 {
        didSet {
            updatePadding()
        }
    }
    
    @IBInspectable var topPadding: CGFloat = 0.0 {
        didSet {
            updatePadding()
        }
    }
    
    @IBInspectable var bottomPadding: CGFloat = 0.0 {
        didSet {
            updatePadding()
        }
    }
    
    
       override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: UIEdgeInsets(top: topPadding,
                                                left: startPadding,
                                                bottom: bottomPadding,
                                                right: endPadding))
       }

       override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding,
                                             left: startPadding,
                                             bottom: bottomPadding,
                                             right: endPadding))
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding,
                                             left: startPadding,
                                             bottom: bottomPadding,
                                             right: endPadding))
       }
}
