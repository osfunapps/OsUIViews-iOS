//
//  UINavigationViewController.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 25/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit
import OsTools

/**
 Extend this view controller to add a navigation view controller to your app
 */
open class UIOsNavigationController: UINavigationController {
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        prepareViewControllerToDisplay(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        prepareViewControllerToDisplay(viewController)
        return super.popToViewController(viewController, animated: animated)
    }
    
    private func prepareViewControllerToDisplay(_ viewController: UIViewController) {
        guard let vcToDisplay = viewController as? UIOsNavigationViewController else {
            return
        }
        
        // Hide back button if required
        viewControllers.last?.hideBackBtnIfNeeded(vcToDisplay.navigationHideSystemBackBtn)
        
        // Prepare for display
        vcToDisplay.prepareToDisplay(navigationController: self)
    }
}

extension UIViewController {
    func hideBackBtnIfNeeded(_ shouldHide: Bool) {
        if shouldHide {
            self.hideBackBtn()
        }
    }
}

open class UIOsNavigationViewControllerImpl: UIOsOrientationViewController {
    
    // MARK: - Static Constants
    public static let sub1Size: CGFloat = 35
    public static let sub2Size: CGFloat = 18
    
    // MARK: - Lifecycle Methods
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(animated: animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Handle transitions if navigating back
        if self.navigationController?.viewControllers.firstIndex(of: self) == nil {
            navigationController?.viewControllers.last?.prepareForDisplayIfNeeded(navigationController: navigationController)
        }
    }
    
    
    // MARK: - Orientation Changes
    open override func orientationDidChanged() {
        updateNavigationAttributesForCurrentOrientation()
    }
    
    // MARK: - Navigation Configuration
    private func configureNavigationBar(animated: Bool) {
        guard let navigationController = navigationController else { return }
        
        if navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
        
        if let navigationTitle = controller().navigationTitle {
            title = navigationTitle
        }
        prepareToDisplay(navigationController: navigationController)
    }
    
    private func updateNavigationAttributesForCurrentOrientation() {
        guard let navigationController = navigationController else {return}
        let fontSize = determineFontSizeForCurrentOrientation()
        let font = controller().navigationTitleFont.withSize(fontSize)
        let color = controller().navigationFontColor
        let backgroundColor = controller().navigationBackgroundColor
        
        var currBackgroundColor = navigationController.navigationBar.backgroundColor
        if #available(iOS 13.0, *) {
            currBackgroundColor = navigationController.navigationBar.standardAppearance.backgroundColor
        }
        
        if currBackgroundColor != backgroundColor {
            navigationController.setBackgroundColor(color: backgroundColor)
        }
        
        navigationController.setTitleFontAndColorIfNeeded(font: font, color: color)
    }
    
    private func determineFontSizeForCurrentOrientation() -> CGFloat {
        let isPortrait = Tools.isPortraitOrientation()
        let device = Tools.getCurrentDevice()
        
        switch (device, isPortrait) {
        case (.phone, true):
            return controller().navigationFontSizePhonePortrait
        case (.phone, false):
            return controller().navigationFontSizePhoneLandscape
        case (.pad, true):
            return controller().navigationFontSizeIpadPortrait
        case (.pad, false):
            return controller().navigationFontSizeIpadLandscape
        default:
            return controller().navigationFontSizePhonePortrait
        }
    }
    
    /// Prepare for initial display or transition
    public func prepareToDisplay(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        
        _ = storeNewOrientation()
        updateNavigationAttributesForCurrentOrientation()
    }
    
    private func controller() -> UIOsNavigationViewController {
        guard let navigationVC = self as? UIOsNavigationViewController else {
            fatalError("ViewController must conform to UIOsNavigationViewController.")
        }
        return navigationVC
    }
}

extension UIViewController {
    func prepareForDisplayIfNeeded(navigationController: UINavigationController?) {
        guard let vcToPrepare = self as? UIOsNavigationViewController else { return }
        vcToPrepare.prepareToDisplay(navigationController: navigationController)
    }
}


// MARK: - Protocol
public protocol OsNavigationViewControllerDelegate {
    /// Return false if you've put a custom back button image
    var navigationHideSystemBackBtn: Bool { get set }
    var navigationTitle: String? { get set }
    var navigationTitleFont: UIFont { get set }
    var navigationFontSizeIpadLandscape: CGFloat { get set }
    var navigationFontColor: UIColor { get set }
    var navigationFontSizeIpadPortrait: CGFloat { get set }
    var navigationFontSizePhonePortrait: CGFloat { get set }
    var navigationFontSizePhoneLandscape: CGFloat { get set }
    var navigationBackgroundColor: UIColor { get set }
}

/// An alias for forcing the child view controllers to implement all of the variables
public typealias UIOsNavigationViewController = UIOsNavigationViewControllerImpl & OsNavigationViewControllerDelegate
