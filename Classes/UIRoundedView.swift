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
//
//  TouchPadView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 07/02/2019.
//  Copyright © 2019 osFunApps. All rights reserved.
//

import Foundation
import UIKit


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
            updateCornerRadius()
        }
    }
    
    /// Will set the corner radius for other devices
    @IBInspectable public var regularCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    /// Will set which corners to round as a string separated by spaces. For example: topLeft topRight. Default to all
    @IBInspectable public var cornersToRound: String = "allCorners" {
        didSet {
            updateCornerRadius()
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
    
    private func updateCornerRadius() {
        let cornerRadius: CGFloat
        if UIDevice.current.userInterfaceIdiom == .phone {
            cornerRadius = compactCornerRadius
        } else {
            cornerRadius = regularCornerRadius
        }
        layer.cornerRadius = cornerRadius
        
        let cornerStrings = cornersToRound.trimmingCharacters(in: .whitespaces).split(separator: " ")
        var maskedCorners: CACornerMask = []
        
        for corner in cornerStrings {
            switch corner {
            case "topLeft":
                maskedCorners.insert(.layerMinXMinYCorner)
            case "topRight":
                maskedCorners.insert(.layerMaxXMinYCorner)
            case "bottomLeft":
                maskedCorners.insert(.layerMinXMaxYCorner)
            case "bottomRight":
                maskedCorners.insert(.layerMaxXMaxYCorner)
            case "allCorners":
                maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default:
                break
            }
        }
        
        layer.maskedCorners = maskedCorners
    }
}

extension CACornerMask {
    static var topLeft: CACornerMask { return .layerMinXMinYCorner }
    static var topRight: CACornerMask { return .layerMaxXMinYCorner }
    static var bottomLeft: CACornerMask { return .layerMinXMaxYCorner }
    static var bottomRight: CACornerMask { return .layerMaxXMaxYCorner }
    
    static let allCorners: CACornerMask = [
        .topLeft, // Top left
        .topRight, // Top right
        .bottomLeft, // Bottom left
        .bottomRight  // Bottom right
    ]
}
