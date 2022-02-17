//
//  CircleBorderUIView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 26/12/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/**
 Just a label with a circle border 
 */
@IBDesignable public class UICircleBorderView : UILabel {
    
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            setBorderColor(color: borderColor)
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            setBorderWidth(width: borderWidth)
        }
    }

    private func setBorderColor(color: UIColor) {
        if let shapeLayer = getShapeLayer() {
            shapeLayer.strokeColor = color.cgColor
        } else {
            drawCircle()
        }
    }
    
    private func setBorderWidth(width: CGFloat) {
        if let shapeLayer = getShapeLayer() {
            shapeLayer.lineWidth = width
        } else {
            drawCircle()
        }
    }
    
    
    public func getShapeLayer() -> CAShapeLayer? {
        guard let sublayers = layer.sublayers else {return nil}
        for sublayer in sublayers {
            if let sublayer = sublayer as? CAShapeLayer {
                return sublayer
            }
        }
        return nil
    }
    
    
    private func drawCircle() {
        self.layer.masksToBounds = false
        let halfSize: CGFloat = min(bounds.size.width/2,
                                   bounds.size.height/2)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: halfSize,y: halfSize),
            radius: CGFloat(halfSize - (borderWidth/2)),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = borderWidth
        layer.addSublayer(shapeLayer)
    }
}

