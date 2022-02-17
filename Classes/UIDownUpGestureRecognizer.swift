//
//  TouchDownGestureRecognizer.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 04/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

/// Just a simple touch down and up gesture recognizer
public class UIDownUpGestureRecognizer: UIGestureRecognizer {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            self.state = .began
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .possible
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
    
}
