//
//  UIPanGestureRecognizerForUITableViewWrapper.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/**
 Attach this gesture to a parent view of UITableView. It meant to forward all of the scrolling events to the table view
 */
public class UIPanGestureRecognizerForUITableViewWrapper: UIPanGestureRecognizer {
    
    /// Override this to return your table view (will not save hard reference to it)
    public var getTableView: (() -> UITableView?)? = nil
    
    /// Set here an extra padding for the bottom scroll, if required
    public var extraBottomPadding: CGFloat = 0
    
    // indications
    private var currY: CGFloat = 0
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let scrollableView = view else {return}
        currY = location(in: scrollableView).y
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let scrollableView = view, let tableView = getTableView?() else {return}
        let y = location(in: scrollableView).y
        let gap = y - currY
        tableView.contentOffset.y -= gap
        currY = y
        return
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        guard let tableView = getTableView?() else {return}
        
        let height = tableView.frame.size.height
        let contentYoffset = tableView.contentOffset.y
        let distanceFromBottom = tableView.contentSize.height - contentYoffset
        if distanceFromBottom < height - extraBottomPadding {
            let lastSection = tableView.numberOfSections - 1
            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
            tableView.scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: true)
            return
        }
        
        if contentYoffset < 0 {
            tableView.setContentOffset(.zero, animated: true)
            return
        }
    }
    
}
