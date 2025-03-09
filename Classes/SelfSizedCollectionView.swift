//
//  SelfSizedCollectionView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabbat on 30/09/2024.
//  Copyright © 2024 osApps. All rights reserved.
//

import Foundation
import UIKit

/**
 A custom `UICollectionView` subclass that automatically adjusts its height based on its content size.
 
 This class observes changes in the content size of the collection view and updates its height accordingly. It includes a fixed height constraint that can dynamically adjust based on the content's height, providing a self-sizing behavior for the collection view.
 
 Properties:
 - `resizeByLayoutChanges`: Determines whether the collection view should resize itself when the content size changes.
 - `maxHeight`: Optional property to set a maximum height for the collection view.
 
 The class also overrides the `intrinsicContentSize` property to ensure the collection view adjusts its intrinsic size when the content changes, allowing it to expand or shrink based on its items.
 */
public class SelfSizedCollectionView: UICollectionView {

    public var resizeByLayoutChanges = true

    /// Optional maximum height for the collection view.
    public var maxHeight: CGFloat? = nil

    /// Height constraint to adjust the collection view's height.
    private var heightConstraint: NSLayoutConstraint?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    /// Common setup for initialization.
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 100)  // Initial height.
        heightConstraint?.isActive = true
    }

    // MARK: - Layout Subviews

    public override func layoutSubviews() {
        super.layoutSubviews()
        if resizeByLayoutChanges {
            updateHeight()
        }
    }

    /// Updates the height constraint based on content size.
    private func updateHeight() {
        var contentHeight = self.collectionViewLayout.collectionViewContentSize.height
        if let maxHeight = maxHeight {
            contentHeight = min(contentHeight, maxHeight)
        }
        
        if heightConstraint?.constant != contentHeight {
            heightConstraint?.constant = contentHeight
            self.invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Intrinsic Content Size

    public override var intrinsicContentSize: CGSize {
        let contentHeight = self.collectionViewLayout.collectionViewContentSize.height
        let height = maxHeight != nil ? min(contentHeight, maxHeight!) : contentHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    public override func reloadData() {
        super.reloadData()
        updateHeight()
    }
    
    
}
