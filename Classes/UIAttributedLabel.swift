//
//  AttributedUILabel.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

// A UILabel which will add bold and regular texts inside a single view.
// To use, just add normal text to the UILabel when the boldi text will be in barckets like so:
// label.text = "this is not boldi text. [this is some boldi text] this isnt. [This is!]"
//
public class UIAttributedLabel: UILabel {
    
    /// The font of the boldi text
    public var boldFont: UIFont = .boldSystemFont(ofSize: 15)
    public var boldColor: UIColor = .black
    
    /// The font of the regular text
    public var regularFont: UIFont = .systemFont(ofSize: 15)
    public var regularColor: UIColor = .black
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        refreshTexts()
    }
    
    /// Will refresh the texts. Externally call if you changed the texts
    public func refreshTexts() {
        guard let text = text else {return}
        var startIdx = -1
        var endIdx = -1
        var counter = -1
        var boldStarted = false
        let fullAttString = NSMutableAttributedString()
        let boldAttribute = [NSAttributedString.Key.font : boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        let regularAttribute = [NSAttributedString.Key.font : regularFont, NSAttributedString.Key.foregroundColor: regularColor]
        for char in text {
            
            counter += 1
            if char == "[" && !boldStarted {
                boldStarted = true
                startIdx = counter
                continue
            }
            
            if char == "]" && boldStarted {
                boldStarted = false
                endIdx = counter
                let boldiText = text.substring(startIdx + 1, endIdx)
                let boldiString = NSMutableAttributedString(string: boldiText, attributes:boldAttribute)
                fullAttString.append(boldiString)
                continue
            }
            
            if !boldStarted {
                let regularString = NSMutableAttributedString(string: String(char), attributes:regularAttribute)
                fullAttString.append(regularString)
            }
        }
        
        attributedText = fullAttString
        
    }
    
}
