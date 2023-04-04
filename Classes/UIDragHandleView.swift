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
    
    // drag bank dragbank drag
    @objc private func handleDidDrag(_ sender: UIPanGestureRecognizer) {
        guard let containerView = superview,
              let rootVCView = UIApplication.shared.windows.first?.rootViewController?.view else {return}
        if dragEndPercentageDict == nil {
            self.buildDefaultDragEndBank(with: containerView)
        }
        let locationY = Tools.getWindowHeight() - sender.location(in: rootVCView).y
        let windowHeight = Tools.getWindowHeight()
        let currPerc = Int((locationY / windowHeight) * 100)
        if sender.state == .changed {
            if locationY >= minimumDrag {
                handleDragEvent?(sender.state, locationY)
                containerView.updateHeightConstraint(newHeight: locationY){}
            }
        } else if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            // when the handle left, we will act according to the percentageDict.
            if let yPoint = findNearestRangeHeight(from: currPerc) {
                handleDragEvent?(sender.state, yPoint)
                containerView.updateHeightConstraint(newHeight: yPoint,
                                                     animateInterval: 0.3){
                    if yPoint == 0.0 {
                        self.delegate?.dragHandleDidMinimized()
                    }
                }
                
            }
        }
    }
    
    private func findNearestRangeHeight(from percent: Int) -> CGFloat? {
        var percentToFind = percent
        if percentToFind < 0 {
            percentToFind = 0
        }
        var closestDistance = Int.max
        var closestRange: ClosedRange<Int>? = nil
        for range in dragEndPercentageDict!.keys {
            let start = range.lowerBound + range.distance(from: range.startIndex, to: range.startIndex)
            let end = range.lowerBound + range.distance(from: range.startIndex, to: range.endIndex)
            
            
            if start <= percentToFind && percentToFind <= end {
                // If the number is inside the range, return the range
                return dragEndPercentageDict![range]
            } else {
                // If the number is outside the range, calculate the distance to the start and end of the range
                let distanceToStart = abs(percentToFind - start)
                let distanceToEnd = abs(percentToFind - end)
                
                let minDistance = min(distanceToStart, distanceToEnd)
                if minDistance < closestDistance {
                    closestRange = range
                    closestDistance = minDistance
                }
                
                // If the current range is farther away than the closest range found so far, break out of the loop
                if closestDistance == 0 {
                    break
                }
            }
        }
        
        if let closestRange = closestRange {
            return dragEndPercentageDict![closestRange]
        }
        return nil
    }
    
    private func buildDefaultDragEndBank(with superview: UIView) {
        dragEndPercentageDict = [0...55: superview.frame.height,
                                 55...100: superview.frame.height,
        ]
    }
}

public protocol UIDragHandleViewDelegate {
    func dragHandleDidMinimized()
}
