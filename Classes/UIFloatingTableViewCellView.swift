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
    @IBOutlet weak var optionalIVSize: NSLayoutConstraint! // ratio 1:1
    @IBOutlet weak var optionalIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedItemIV: UIImageView!
    @IBOutlet weak var selectedItemIVHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedItemIVWidth: NSLayoutConstraint!
}

