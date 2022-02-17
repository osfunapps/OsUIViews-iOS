//
//  UIRotatedImageView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 06/02/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// A simple UIImageView that can be rotated initially to save code
@IBDesignable public class UIRotatedImageView: UIImageView {
    
    @IBInspectable var rotateDegree: CGFloat = 0.0 {
        didSet {
            rotate(angle: rotateDegree)
        }
    }
}
