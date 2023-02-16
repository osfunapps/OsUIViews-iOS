//
//  UIBorderedView.swift
//  TelegraphWebServer
//
//  Created by Oz Shabbat on 09/02/2023.
//

import Foundation
import UIKit

// just a simple view with border for the lazy
@IBDesignable public class UIBorderedView: UIView {
    
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
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

