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
 A simplified complete circle view (height, width  / 2)
 */
@IBDesignable public class UICircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
//        self.layer.masksToBounds = false
    }
}
