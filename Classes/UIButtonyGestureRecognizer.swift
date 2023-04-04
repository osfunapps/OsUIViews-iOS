//
//  MakeButtoni.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 12/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/// The main button effect gesture recognizer in the app.
/// Add to every button to create a similar button effects to all of them when tapped
@IBDesignable
public class UIButtonyGestureRecognizer: UITapGestureRecognizer {
    
    /// Set a target scale to override the default scale
    @IBInspectable open var targetScaleX: CGFloat = 0.72 {
        didSet {
            self.manuallySetTargetScaleX = true
        }
    }
    @IBInspectable open var targetScaleY: CGFloat = 0.72 {
        didSet {
            self.manuallySetTargetScaleY = true
        }
    }
    
    public var originalXScale: CGFloat = 0.0
    public var originalYScale: CGFloat = 0.0
    
    // indications
    private var manuallySetTargetScaleY = false
    private var manuallySetTargetScaleX = false
    
    private static let DEFAULT_TARGET_SCALE_X = 0.72
    private static let DEFAULT_TARGET_SCALE_Y = 0.72
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else {return}
        originalXScale = view.transform.a
        originalYScale = view.transform.d
        if !self.manuallySetTargetScaleY {
            self.targetScaleY = UIButtonyGestureRecognizer.DEFAULT_TARGET_SCALE_Y
            manuallySetTargetScaleY = false
        }
        if !self.manuallySetTargetScaleX {
            self.targetScaleX = UIButtonyGestureRecognizer.DEFAULT_TARGET_SCALE_X
            manuallySetTargetScaleX = false
        }
        UIButtonyGestureRecognizer.buttonyEffectBegin(view: view,
                                                      originalXScale: originalXScale,
                                                      originalYScale: originalYScale,
                                                      targetScaleX: self.targetScaleX,
                                                      targetScaleY: self.targetScaleY)
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else {return}
        UIButtonyGestureRecognizer.buttonyEffectDone(view: view, originalXScale: originalXScale, originalYScale: originalYScale)
        state = .recognized
    }
    
    
    /// Override in your touches began function to start the button effect
    public static func buttonyEffectBegin(view: UIView,
                                          originalXScale: CGFloat = 1.0,
                                          originalYScale: CGFloat = 1.0,
                                          targetScaleX: CGFloat = 0.72,
                                          targetScaleY: CGFloat = 0.72,
                                          _ completion: ((Bool) -> Void)? = nil) {
        let targetTransformX: CGFloat = originalXScale * targetScaleX
        let targetTransformY: CGFloat = originalYScale * targetScaleY
        UIView.animate(withDuration: 0.15,
                       animations: {
            view.transform = CGAffineTransform(scaleX: targetTransformX, y: targetTransformY)
        },
                       completion: completion)
    }
    
    
    /// Override in your touches began function to end the button effect
    public static func buttonyEffectDone(view: UIView,
                                         originalXScale: CGFloat = 1.0,
                                         originalYScale: CGFloat = 1.0,
                                         _ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.15,
                       animations: {
            view.transform = CGAffineTransform(scaleX: originalXScale, y: originalYScale)
        },
                       completion: completion)
    }
}

