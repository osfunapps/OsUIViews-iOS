//
//  UIAnimatedTopBar.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/10/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

class UIBottomBarView: UIView {
    
    // views
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var itemsSVTopConstr: NSLayoutConstraint!
    @IBOutlet weak var itemsSV: UIStackView!
    @IBOutlet weak var contentHolderHeightConstr: NSLayoutConstraint!
    
    // user adjust
    var delegate: UIBottomBarViewDelegate? = nil
    
    // selected
    var selectedItemTextColor: UIColor? = nil
    var selectedItemFont: UIFont? = nil
    var unselectedItemTextColor: UIColor? = nil
    var unselectedItemFont: UIFont? = nil
    
    // indications
    private var lastSelectedItemTag: Int = 0
    private var lastMeasuredViewHeight: CGFloat = 0
    var isExpanded = true
    
    // scrollview
    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    var lastOffsetCapture: TimeInterval = 0
    var isScrollingFast: Bool = false
    
    /// init option 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// init option 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// shared init to set contraints
    private func commonInit() {
        Bundle.main.loadNibNamed("UIBottomBarView", owner: self, options: nil);
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setConstraints(contentView: contentView)
        //        itemsSV.isHidden = true
        if let heightConstr = getHeightConstraint() {
            contentHolderHeightConstr.constant = heightConstr.constant
        }
    }
    
    /// will adjust the constraints of the custom view to be at the right place you
    /// set it in the storyboard (connecting the constraints to their right locations)
    private func setConstraints(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentView.superview!.bottomAnchor).isActive = true
    }
    
    /// Will set the currently selected item
    public func setSelectedItem(tag: Int) {
        guard let itemView = itemsSV.viewWithTag(self.lastSelectedItemTag) as? UIBottomBarItemView else {return}
        setSelectedView(itemView: itemView)
    }
    
    /// Will add an item with/o icon and with/o title with a click selector
    public func addItem(itemTag: Int,
                        title: String? = nil,
                        imageName: String? = nil,
                        selectedImageName: String? = nil) {
        let itemView = UIBottomBarItemView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        if let imageName = imageName {
            itemView.iv.image = UIImage(named: imageName)
            itemView.iv.image!.accessibilityIdentifier = imageName
            itemView.iv.accessibilityIdentifier = selectedImageName
            itemView.iv.isHidden = false
        } else {
            itemView.iv.isHidden = true
        }
        itemView.titleLabel.text = title
        itemView.isUserInteractionEnabled = true
        itemView.tag = itemTag
        let gesture = UIButtonyGestureRecognizer(target: self, action: #selector(itemDidTap))
        itemView.addGestureRecognizer(gesture)
        itemsSV.addArrangedSubview(itemView)
        itemView.pinToParentBottom(toMargins: false, constant: 0)
        itemView.titleLabel.font = unselectedItemFont
        setTitleLabel(view: itemView,
                      font: unselectedItemFont,
                      textColor: unselectedItemTextColor)
        itemView.titleLabel.textColor = unselectedItemTextColor
        itemView.pinToParentTop()
        itemsSV.tag = 99
        self.layoutIfNeeded()
        superview!.layoutIfNeeded()
        contentHolderView.backgroundColor = .white
    }
    
    @objc private func itemDidTap(gr: UITapGestureRecognizer) {
        guard let view = gr.view as? UIBottomBarItemView else {return}
        if lastSelectedItemTag == view.tag {
            return
        }
        setSelectedView(itemView: view)
        delegate?.bottomBarViewDidItemTap(self, id: view.tag)
    }
    
    /// Will switch the old and new views selection design
    private func setSelectedView(itemView: UIBottomBarItemView) {
        switchImage(view: itemView)
        setTitleLabel(view: itemView,
                      font: selectedItemFont,
                      textColor: selectedItemTextColor)
        itemView.scale(by: 1.15)
        print("Searching for tag: \(self.lastSelectedItemTag)")
        if let lastItemView = itemsSV.viewWithTag(self.lastSelectedItemTag) as? UIBottomBarItemView {
            switchImage(view: lastItemView)
            setTitleLabel(view: lastItemView,
                          font: unselectedItemFont,
                          textColor: unselectedItemTextColor)
            lastItemView.scale(by: 1)
        }
        self.lastSelectedItemTag = itemView.tag
    }
    
    
    /// Will switch an image to an item, if legal
    private func switchImage(view: UIBottomBarItemView) {
        
        // get alternative image name
        guard let alternateImageName = view.iv.accessibilityIdentifier else {return}
        
        // get current image name
        var currImageName: String? = nil
        if let currFtchedImageName = view.iv.image?.accessibilityIdentifier {
            currImageName = currFtchedImageName
        }
        
        // switcharoo
        view.iv.image = UIImage(named: alternateImageName)
        view.iv.image!.accessibilityIdentifier = alternateImageName
        view.iv.accessibilityIdentifier = currImageName
    }
    
    /// Will set the title to an item, if legal
    private func setTitleLabel(view: UIBottomBarItemView,
                               font: UIFont? = nil,
                               textColor: UIColor? = nil) {
        if let font = font {
            view.titleLabel.font = font
        }
        
        if let textColor = textColor {
            view.titleLabel.textColor = textColor
        }
    }
    
}


// MARK: - Scroll delegate
extension UIBottomBarView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        if scrollView.isAtBottom {
            return
        } else if scrollView.isAtTop {
           expand()
            return
        }
        
        let timeDiff = currentTime - lastOffsetCapture
        if timeDiff > 0.1 {
            let distance = currentOffset.y - lastOffset.y
            //The multiply by 10, / 1000 isn't really necessary.......
            let scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
            
            let scrollSpeed = abs(scrollSpeedNotAbs)
            
            if scrollSpeed > 0.25 {
                isScrollingFast = true
                if scrollSpeedNotAbs > 0 {
                    minimize()
                } else {
                    expand()
                }
//                print("Scrolling pretty fast!")
            } else {
                
                isScrollingFast = false
//                print("Scrolling pretty slow!")
            }
            
            lastOffset = currentOffset;
            lastOffsetCapture = currentTime
        }
        
    }
    
    /// Will expand the bottom bar, if legal
    public func expand() {
        if isExpanded {return}
        isExpanded = true
        
        guard let bottomConstr = getConstraintWithParent(attributes: [.bottom, .bottomMargin]) else {return}
        
        bottomConstr.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.layoutIfNeeded()
        })
        
        self.itemsSVTopConstr.constant = 0
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 3.5,
                       options: .curveLinear,
                       animations: {
            self.itemsSV.superview!.layoutIfNeeded()
        })
    }
    
    /// Will minimize the bottom bar, if legal
    func minimize() {
        if !isExpanded {return}
        clipsToBounds = true
        isExpanded = false
        
        lastMeasuredViewHeight = contentHolderHeightConstr.constant
//        contentHolderHeightConstr.constant = 0
//        clipsToBounds = true
        
        guard let bottomConstr = getConstraintWithParent(attributes: [.bottom, .bottomMargin]) else {return}
        
        bottomConstr.constant = -lastMeasuredViewHeight - 75 // safe number here
        UIView.animate(withDuration: 0.6, animations: {
            self.superview?.layoutIfNeeded()
        })
        
        self.itemsSVTopConstr.constant = lastMeasuredViewHeight + 75
        UIView.animate(withDuration: 0.45, animations: {
            self.itemsSV.superview!.layoutIfNeeded()
        })
        
    }
}

/// override this delegate to get item tap events
protocol UIBottomBarViewDelegate {
    func bottomBarViewDidItemTap(_ bottomBar: UIBottomBarView, id: Int)
}

