//
//  UIGradientView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 01/10/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class UIGradientView: UIView {
    @IBInspectable public var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable public var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable public var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable public var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable public var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable public var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = .init(x: 0.5, y: 1)
//            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
//            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
