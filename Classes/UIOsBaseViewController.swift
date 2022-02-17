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
        appDidReturnedFromBackground()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDidEnteredBackground()
        LifeCycleRegistrator.unregisterFromLifeCycleEvents(viewController: self)
    }
}
extension UIOsBaseViewController: LifeCycleDelegate {
    
    /// Override to do something when the app returned from background
    @objc open func appDidReturnedFromBackground() {}
    
    /// Override to do something when the app entered background
    @objc open func appDidEnteredBackground() {}
    
    
}
