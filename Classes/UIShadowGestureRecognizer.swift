//
//  UIShadowGestureRecognizer.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 06/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// This effect will resize the button and hide/show the view with each down/up action
@IBDesignable public class UIShadowGestureRecognizer: UITapGestureRecognizer {
    
    /// Will set the border color
    @IBInspectable var recognizeOnlyTap: Bool = true
    
    /// Will hold the view's shadow original opacity
    private var originalOpacity: Float = 1.0
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let view = view else {return}
        originalOpacity = view.layer.shadowOpacity
        UIView.animate(withDuration: 0.3,
                       animations: {
            view.layer.shadowOpacity = 0
        })
        UIButtonyGestureRecognizer.buttonyEffectBegin(view: view)
        if !recognizeOnlyTap {
            self.state = .began
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .possible
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let view = view else {return}
        UIView.animate(withDuration: 0.3,
                       animations: {
            view.layer.shadowOpacity = self.originalOpacity
        })
        
        UIButtonyGestureRecognizer.buttonyEffectDone(view: view)
        self.state = .ended
    }
}


