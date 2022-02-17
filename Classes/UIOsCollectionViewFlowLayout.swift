//
//  UIOsCollectionViewFlowLayout.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 30/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class UIOsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    @IBInspectable var phoneSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.itemSize.width = phoneSize.width
                self.itemSize.height = phoneSize.height
            }
        }
    }
    
    /// Will set the corner radius for other devices
    @IBInspectable var ipadSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            if UIDevice.current.userInterfaceIdiom != .phone {
                self.itemSize.width = phoneSize.width
                self.itemSize.height = phoneSize.height
            }
        }
    }
}
