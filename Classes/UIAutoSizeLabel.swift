//
//  UIAutoSizeLabel.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 04/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// NOTICE:: PLEASE DO NOT USE THIS LABEL!!!!
/// IT JUST MEANT TO SERVE AS A WAY TO SHOW YOU HOW TO IMPLEMENT A UILABEL WITH ADJUSTABLE SIZE BY WIDTH!!!
///
///
// An example of UILabel which will resize itself by the font size
// NOTICE: You gotta add width constraint to this view (like width = parent width * 0.5)
@IBDesignable public class UIAutoSizeLabel: UILabel {
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        lineBreakMode = .byWordWrapping
        numberOfLines = 1
        minimumScaleFactor = 0.25
        adjustsFontSizeToFitWidth = true
    }
}
    
