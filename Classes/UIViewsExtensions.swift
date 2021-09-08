//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation

extension UIView {
    
    /// Wil return the height constraint, if exists
    public func getHeightConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if let firstItem = constraint.firstItem,
               let firstObj = firstItem as? NSObject,
               firstObj == self,
               constraint.firstAttribute == .height {
                return constraint
            } else if let secondItem = constraint.secondItem,
                      let secondObj = secondItem as? NSObject,
                      secondObj == self,
                      constraint.secondAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    /// Wil return the top constraint, if exists
    public func getTopConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if let firstItem = constraint.firstItem,
               let firstObj = firstItem as? NSObject,
               firstObj == self,
               constraint.firstAttribute == .top {
                return constraint
            } else if let secondItem = constraint.secondItem,
                      let secondObj = secondItem as? NSObject,
                      secondObj == self,
                      constraint.secondAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    /// Wil update a view height constraint. If the height constraint doesn't exists, will create it. For disabling animation, put 0.0 in the interval
    public func updateHeightConstraint(newHeight: CGFloat, animateInterval: TimeInterval = 0.0) {
        guard let superview = superview else {return}
        var heightConstr = getHeightConstraint()
        if heightConstr == nil {
            heightConstr = setHeight(height: 0)
            layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            heightConstr!.constant = newHeight
            if animateInterval != 0.0 {
                UIView.animate(withDuration: animateInterval, animations: {
                    superview.layoutIfNeeded()
                })
            }
        }
    }
}
