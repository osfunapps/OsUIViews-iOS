//
//  MakeButtoni.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 12/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//
@IBDesignable
public class UIButtonyGestureRecognizer: UITapGestureRecognizer {
    
    @IBInspectable open var targetScaleX: CGFloat = ButtonyEffects.defaultTargetScaleX
    @IBInspectable open var targetScaleY: CGFloat = ButtonyEffects.defaultTargetScaleY
    
    public var originalXScale: CGFloat = 0.0
    public var originalYScale: CGFloat = 0.0
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view else { return }
        // Store the original scale
        originalXScale = view.transform.a
        originalYScale = view.transform.d
        
        // Apply the scaling effect
        Task {[weak self] in
            guard let self = self else {return}
            await ButtonyEffects.beginEffect(on: view,
                                             originalXScale: originalXScale,
                                             originalYScale: originalYScale,
                                             targetScaleX: targetScaleX,
                                             targetScaleY: targetScaleY)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Do nothing when the touch moves (no scaling if the finger moves outside the button).
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view, let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: view)
        
        Task {[weak self] in
            guard let self = self else {return}
            if view.bounds.contains(touchLocation) {
                // Finger released inside the button
                await ButtonyEffects.endEffect(on: view, originalXScale: originalXScale, originalYScale: originalYScale)
                state = .recognized
            } else {
                // Finger released outside the button
                await ButtonyEffects.endEffect(on: view, originalXScale: originalXScale, originalYScale: originalYScale)
                state = .cancelled
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view,
        let event = event else { return }
        super.touchesCancelled(touches, with: event)
        // Reset the scale on cancellation
        Task {[weak self] in
           guard let self = self else {return}
            await ButtonyEffects.endEffect(on: view, originalXScale: originalXScale, originalYScale: originalYScale)
        }
        state = .cancelled
    }
}

extension UIButtonyGestureRecognizer: UIGestureRecognizerDelegate {
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }

    // Allow simultaneous gesture recognition
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
