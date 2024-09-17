//
//  CastStripContainerView.swift
//  TelegraphWebServer
//
//  Created by Oz Shabbat on 12/02/2023.
//

import Foundation
import UIKit
import OsTools

/**
 Add this view to a view which you would like to drag. The dragging will occur whenever the user will drag this view.
 Set the percentage bank to decide what to do whenever a dragging will end.
 
 NOTICE: make sure that:
 1) The parent of this view is the draggable view you would like to drag
 2) The parent of this view is attached to HIS parent bottom
 3) The parent of this view's height will be adjusted from here, so make sure the parent can have changes to it's height constraint
 */
public class UIDragHandleView: UIView {
    
    // instances
    public var delegate: UIDragHandleViewDelegate? = nil
    
    // indications
    public var dragEndPercentageDict: [ClosedRange<Int>: CGFloat]?
    public var minimumDrag: CGFloat = -100.0
    
    /** sign in to drag events */
    public var handleDragEvent: ((UIGestureRecognizer.State, CGFloat) -> ())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDidDrag)))
    }
}

// MARK: - Drag Handle Methods
extension UIDragHandleView {
    
    
    @objc private func handleDidDrag(_ sender: UIPanGestureRecognizer) {
        guard let bottomConstr = delegate?.dragHandleRequestBottomConstr(),
              let rootParentView = delegate?.dragHandleRequestRootView()?.superview else {
            return
        }
        
        let locationY = Tools.getWindowHeight() - sender.location(in: nil).y
        let windowHeight = Tools.getWindowHeight()
        let currPerc = Int((locationY / windowHeight) * 100)

        switch sender.state {
        case .changed:
            if locationY >= minimumDrag {
                handleDragEvent?(sender.state, locationY)
                updateBottomConstraint(with: locationY, constraint: bottomConstr, rootParentView: rootParentView)
            }
        case .ended, .cancelled, .failed:
            if let yPoint = findNearestRangeHeight(from: currPerc) {
                handleDragEvent?(sender.state, yPoint)
                updateBottomConstraint(with: yPoint, forDuration: 0.3, constraint: bottomConstr, rootParentView: rootParentView) {
                    if yPoint == 0.0 {
                        self.delegate?.dragHandleDidMinimized()
                    }
                }
            }
        default:
            break
        }
    }

    private func updateBottomConstraint(with yPosition: CGFloat,
                                        forDuration duration: CGFloat = 0.17,
                                        constraint: NSLayoutConstraint,
                                        rootParentView: UIView, completion: (() -> Void)? = nil) {
        let newConstant = Tools.getWindowHeight() - yPosition
        constraint.constant = newConstant

        UIView.animate(withDuration: duration, animations: {
            rootParentView.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }

    private func findNearestRangeHeight(from percent: Int) -> CGFloat? {
        let validPercent = max(percent, 0)
        var closestRange: ClosedRange<Int>? = nil
        var closestDistance = Int.max

        for range in dragEndPercentageDict!.keys {
            let (start, end) = (range.lowerBound, range.upperBound)
            if validPercent >= start && validPercent <= end {
                return dragEndPercentageDict![range]
            }
            
            let distanceToStart = abs(validPercent - start)
            let distanceToEnd = abs(validPercent - end)
            let minDistance = min(distanceToStart, distanceToEnd)
            
            if minDistance < closestDistance {
                closestDistance = minDistance
                closestRange = range
            }
        }

        return closestRange.flatMap { dragEndPercentageDict![$0] }
    }

    
    private func buildDefaultDragEndBank(with superview: UIView) {
        dragEndPercentageDict = [0...55: superview.frame.height,
                                 55...100: superview.frame.height,
        ]
    }
}

public protocol UIDragHandleViewDelegate {
    func dragHandleDidMinimized()
    func dragHandleRequestBottomConstr() -> NSLayoutConstraint?
    func dragHandleRequestRootView() -> UIView?
}
