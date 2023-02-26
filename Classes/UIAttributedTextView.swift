//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation
import UIKit

/**
 This is just a  simple text view with the possibility to set the color resource for attributed text
 */
public class UIAttributedTextView: UITextView {
    
    @IBInspectable public var generalTextColor: UIColor = .black {
        didSet {
            paintAllText(color: generalTextColor)
        }
    }
    
    private func paintAllText(color: UIColor) {
        guard let attribText = attributedText else {return}
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attribText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: color,
                                             range: NSRange.init(0...attribText.string.count-1))
        
        attributedText = mutableAttributedString
    }
    
}

