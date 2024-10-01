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
 
 The class also overrides the `intrinsicContentSize` property to ensure the collection view adjusts its intrinsic size when the content changes, allowing it to expand or shrink based on its items.
 */
public class SelfSizedCollectionView: UICollectionView {

    public var resizeByLayoutChanges = true

    /// Height constraint to adjust the collection view's height.
    private var heightConstraint: NSLayoutConstraint?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    /// Common setup for initialization.
    private func setup() {
        
        // Add height constraint.
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 100)  // Initial height.
        heightConstraint?.isActive = true

        // Observe content size changes.
        self.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    deinit {
        self.removeObserver(self, forKeyPath: "contentSize")
    }

    // MARK: - KVO for contentSize
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let contentHeight = self.collectionViewLayout.collectionViewContentSize.height
        if keyPath == "contentSize", resizeByLayoutChanges {
            updateHeight()
        }
    }

    /// Updates the height constraint based on content size.
    private func updateHeight() {
        let contentHeight = self.collectionViewLayout.collectionViewContentSize.height
        heightConstraint?.constant = contentHeight
        self.invalidateIntrinsicContentSize()
        self.superview?.layoutIfNeeded()
    }

    // MARK: - Intrinsic Content Size

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: self.collectionViewLayout.collectionViewContentSize.height)
    }
    
    public override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
}

