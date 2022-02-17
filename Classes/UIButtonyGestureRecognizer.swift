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
public class UIButtonyGestureRecognizer: UITapGestureRecognizer {
    
    public var originalXScale: CGFloat = 0.0
    public var originalYScale: CGFloat = 0.0
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else {return}
        originalXScale = view.transform.a
        originalYScale = view.transform.d
        UIButtonyGestureRecognizer.buttonyEffectBegin(view: view, originalXScale: originalXScale, originalYScale: originalYScale)
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
                                          _ completion: ((Bool) -> Void)? = nil) {
        let targetTransformX: CGFloat = originalXScale * 0.72
        let targetTransformY: CGFloat = originalYScale * 0.72
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

