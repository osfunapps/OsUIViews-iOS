//
//  UIRadioLabelView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 07/10/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation
import UIKit

public class UISwitchLabelView: UISwitch {
    
    // labels
    @objc @IBOutlet open weak var offLabel: UILabel?
    @objc @IBOutlet open weak var onLabel: UILabel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        attachLabels()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        attachLabels()
    }
    
    private func attachLabels() {
        subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.8392156863, blue: 0.4431372549, alpha: 1)
        addTarget(self, action: #selector(switchDidChanged), for: .valueChanged)
    }
    
    /// Will change the labels according to the switch status.
    /// Call this functions from outside if you're setting the status programatically
    @objc public func switchDidChanged() {
        if isOn {
            enableLabel(label: offLabel, enable: false)
            enableLabel(label: onLabel, enable: true)
        } else {
            enableLabel(label: offLabel, enable: true)
            enableLabel(label: onLabel, enable: false)
        }
    }
    
    private func enableLabel(label: UILabel?, enable: Bool) {
        guard let _label = label else {return}
        var destAlpha: CGFloat = 1.0
        let currAlpha = _label.alpha
        var font = UIFont.boldSystemFont(ofSize: _label.font.pointSize)
        if !enable {
            destAlpha = 0.2
            font = UIFont.systemFont(ofSize: _label.font.pointSize)
        }
        _label.font = font
        _label.alpha = destAlpha
        Task {@MainActor [weak self] in
            guard let self = self else {return}
            await _label.fade(fromAlpha: currAlpha,
                              toAlpha: destAlpha, hideAtEnd: true, animationOptions: .curveEaseIn)
        }
        label?.isUserInteractionEnabled = enable
    }
    
    
}
