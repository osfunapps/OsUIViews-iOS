//
//  UICircleView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 03/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//


import Foundation
import UIKit

/**
 Just a circle view with optional border
 */
@IBDesignable public class UICircleView: UIView {
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
}
