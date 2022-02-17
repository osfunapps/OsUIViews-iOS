//
//  TouchPadView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 07/02/2019.
//  Copyright © 2019 osFunApps. All rights reserved.
//

import Foundation
import UIKit

// is a view with radius modifiers
//
// to use: in the editor, under User Defined Runtime Attributes:
//cornerRadius Number 30
@IBDesignable public class UIRoundedView: UIView {
    
    /// Will set the border color
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Will set the border width
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// Will set the corner radius for phones
    @IBInspectable public var compactCornerRadius: CGFloat = 0.0 {
        didSet {
            if UIDevice.current.userInterfaceIdiom == .phone {
                layer.cornerRadius = compactCornerRadius
            }
        }
    }
    
    /// Will set the corner radius for other devices
    @IBInspectable public var regularCornerRadius: CGFloat = 0.0 {
        didSet {
            if UIDevice.current.userInterfaceIdiom != .phone {
                layer.cornerRadius = regularCornerRadius
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
}
