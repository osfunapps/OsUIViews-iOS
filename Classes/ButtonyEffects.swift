//
//  MakeButtoni.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 12/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import UIKit

public class ButtonyEffects {
    
    public static let defaultTargetScaleX: CGFloat = 0.92
    public static let defaultTargetScaleY: CGFloat = 0.92
    
    /// Begin the button scaling effect
    @MainActor
    public static func beginEffect(on view: UIView,
                                   originalXScale: CGFloat = 1.0,
                                   originalYScale: CGFloat = 1.0,
                                   targetScaleX: CGFloat = defaultTargetScaleX,
                                   targetScaleY: CGFloat = defaultTargetScaleY) async {
        await withCheckedContinuation {continuation in
            let targetTransformX: CGFloat = originalXScale * targetScaleX
            let targetTransformY: CGFloat = originalYScale * targetScaleY
            UIView.animate(withDuration: 0.15,
                           animations: {
                view.transform = CGAffineTransform(scaleX: targetTransformX, y: targetTransformY)
            },
                           completion: { _ in
                continuation.resume()
            })
        }
    }
    
    /// End the button scaling effect
    @MainActor
    public static func endEffect(on view: UIView,
                                 originalXScale: CGFloat = 1.0,
                                 originalYScale: CGFloat = 1.0) async {
        await withCheckedContinuation {continuation in
            UIView.animate(withDuration: 0.15,
                           animations: {
                view.transform = CGAffineTransform(scaleX: originalXScale, y: originalYScale)
            },
                           completion: { _ in
                continuation.resume()})
        }
    }
}
