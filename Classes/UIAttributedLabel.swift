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
    
    /// other params
    public var lineSpacing: CGFloat = 3
    
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
        setAttrbiutedText(text: text,
                          normalTextFont: regularFont,
                          normalTextColor: regularColor,
                          attributedTextFont: boldFont,
                          attributedTextColor: boldColor,
                          lineSpacing: lineSpacing,
                          alignment: self.textAlignment)
    }
    
}
