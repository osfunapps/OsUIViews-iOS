//
//  SelfSizedTableView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/02/2019.
//  Copyright © 2019 osFunApps. All rights reserved.
//

import Foundation
import UIKit


/**
 A `UITableView` subclass that automatically adjusts its height based on its content or a static value.

 This class provides functionality to either:
 - Dynamically resize the table view height according to its content, up to a specified maximum height (`maxHeight`).
 - Use a fixed static height (`staticHeight`), depending on the `isStaticHeight` property.

 Properties:
 - `maxHeight`: The maximum dynamic height the table can grow to. Settable from the storyboard.
 - `isStaticHeight`: A flag to switch between static and dynamic height modes. Settable from the storyboard.
 - `staticHeight`: The static height to use if `isStaticHeight` is true. Settable from the storyboard.

 The table view's intrinsic content size is recalculated whenever data is reloaded or layout updates are triggered, ensuring that the view properly resizes based on the content or remains at the defined static height.

 Methods:
 - `reloadData()`: Reloads the table view data and invalidates the intrinsic content size, causing the layout to update.
 - `layoutSubviews()`: Ensures layout updates whenever the table view is resized or its layout changes.
 */
public class SelfSizedTableView: UITableView {

    // Maximum dynamic height, can be set from storyboard
    @IBInspectable public var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    // Flag to toggle between static and dynamic height, can be set from storyboard
    @IBInspectable public var isStaticHeight: Bool = false
    
    // Static height value, can be set from storyboard
    @IBInspectable public var staticHeight: CGFloat = 200  // Default static height

    // Dynamically calculate the intrinsic content size
    public override var intrinsicContentSize: CGSize {
        let verticalAdd = contentInset.top + contentInset.bottom
        if isStaticHeight {
            // Use the static height when the flag is set
            return CGSize(width: UIView.noIntrinsicMetric, height: staticHeight + verticalAdd)
        } else {
            // Use content height but cap it at maxHeight
            let height = min(contentSize.height + verticalAdd, maxHeight)
            return CGSize(width: contentSize.width, height: height)
        }
    }
    
    // Invalidate the intrinsic content size after reloading data
    public override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    // Ensure layout updates whenever needed
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
}


