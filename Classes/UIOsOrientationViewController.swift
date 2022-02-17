//
//  UIOrientationViewController.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 25/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit
import OsTools

/**
 This view controller returns orientation events for the user
 */
public class UIOsOrientationViewController: UIOsBaseViewController {
    
    private var lastReportedOrientation: UIDeviceOrientation? = nil
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        orientationLayoutSubviews()
    }
}

extension UIOsOrientationViewController: OrientationChangeDelegate {
    
    public func setLastReportedOrientation(newOrientation: UIDeviceOrientation) {
        self.lastReportedOrientation = newOrientation
    }
    
    public func getLastReportedOrientation() -> UIDeviceOrientation? {
        return lastReportedOrientation
    }
    
    /// Override to get iPad portrait notification
    @objc open func orientationChangeiPadPortrait() {}
    
    /// Override to get iPad landscape notification
    @objc open func orientationChangeiPadLandscape() {}
    
    /// Override to get phone portrait notification
    @objc open func orientationChangePhonePortrait() {}
    
    /// Override to get phone landscape notification
    @objc open func orientationChangePhoneLandscape() {}
    
    /// Override to get a notification about every change in orientation
    @objc open func orientationDidChanged() {}
}
