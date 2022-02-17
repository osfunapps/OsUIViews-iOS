//
//  SelfSizedTableView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/02/2019.
//  Copyright © 2019 osFunApps. All rights reserved.
//

import Foundation
import UIKit

// a table view which resize according to it's content. Make sure to set it's maximum size when instantiate it: formTableView.maxHeight = 1800.
// Tip: to cancel the red dot in the story board editor, add ad intrisic height to the table view (a height which can be seen only in the build phase)
public class SelfSizedTableView: UITableView {
    
    public var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    public override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    public override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height + 10, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
    
}
