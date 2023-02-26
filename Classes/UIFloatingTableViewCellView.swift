//
//  BottomInformationDialogView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import UIKit
import OsTools

class UIFloatingTableViewCellView: UITableViewCell {
    
    // holds title stack view and selected item gap
    @IBOutlet weak var parentSV: UIStackView!
    
    // holds image view and title label gap
    @IBOutlet weak var titleSV: UIStackView!
    
    // optional image view
    @IBOutlet weak var optionalIV: UIImageView!
    @IBOutlet weak var optionalIVSize: NSLayoutConstraint! // ratio 1:1
    
    // label
    @IBOutlet weak var titleLabel: UILabel!
    
    // optional selected item indicator
    @IBOutlet weak var selectedItemIndicatorIV: UIImageView!
    @IBOutlet weak var selectedItemIVHeight: NSLayoutConstraint!  // ratio 1:1
    
    // new item indicator
    @IBOutlet weak var newItemIndicatorIVHeight: NSLayoutConstraint!
    @IBOutlet weak var newItemIndicatorView: UICircleView!
}

