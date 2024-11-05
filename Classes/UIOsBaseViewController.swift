//
//  UIOsBaseViewController.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 25/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit
import OsTools

/**
 This base view controller will implement all of the basic functionality an app needs
 */
open class UIOsBaseViewController: UIViewController {
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LifeCycleRegistrator.registerToLifeCycleEvents(viewController: self, delegate: self)
        osAppsAppDidReturnedFromBackground()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        osAppsAppDidEnteredBackground(minimized: false)
        LifeCycleRegistrator.unregisterFromLifeCycleEvents(viewController: self)
    }
}

extension UIOsBaseViewController: LifeCycleDelegate {
    
    @objc final public func appDidReturnedFromBackground() {
        osAppsAppDidReturnedFromBackground()
    }
    
    @objc final public func appDidEnteredBackground() {
        osAppsAppDidEnteredBackground(minimized: true)
    }
    
    /// Override to do something when the app returned from background
    @objc open func osAppsAppDidReturnedFromBackground() {}
    
    /// Override to do something when the app entered background (minimized will idicate if the app went completely to the background and not just
    /// a view controller change
    @objc open func osAppsAppDidEnteredBackground(minimized: Bool) {}
    
    
}
