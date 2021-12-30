//
//  AttributedUILabel.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/**
 This class meant to display a vertical list of attributed labels (labels with regular and bold texts).
 To learn about how to use the attributed text labels, read AttributedUILabel
 */
public class UIInstructionalStackView: UIStackView {
    
    // set the fonts here
    public var boldFont: UIFont = .boldSystemFont(ofSize: 15)
    public var boldColor: UIColor = .black
    public var regularFont: UIFont = .systemFont(ofSize: 15)
    public var regularColor: UIColor = .black
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        
        // default axis is vertical
        axis = .vertical
    }
    
    /// Call this function to add a label to the stack
    @discardableResult
    public func addLabel(text: String,
                         customSpacingTop: CGFloat? = nil,
                         customSpacingBottom: CGFloat? = nil) -> UILabel {
//        setNeedsLayout()
//        layoutIfNeeded()
        let label = UIAttributedLabel()
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.boldFont = boldFont
        label.regularFont = regularFont
        label.regularColor = regularColor
        label.boldColor = boldColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.refreshTexts()
        if let customSpacingTop = customSpacingTop,
           let lastSubview = arrangedSubviews.last {
            if #available(iOS 11.0, *) {
                setCustomSpacing(customSpacingTop, after: lastSubview)
            } else {
                // Fallback on earlier versions
            }
        }
        addArrangedSubview(label)
        label.pinToLeadingOfParent()
        label.pinToTrailingOfParent()
        if let customSpacingBottom = customSpacingBottom {
            if #available(iOS 11.0, *) {
                setCustomSpacing(customSpacingBottom, after: label)
            } else {
                // Fallback on earlier versions
            }
        }
        label.refreshLayout()
        label.sizeToFit()
        
        return label
    }
    
}
