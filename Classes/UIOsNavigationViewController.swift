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
public class UIOsNavigationController: UINavigationController {
    
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
        
        if vcToDisplay.navigationHideSystemBackBtn {
            if let currVC = viewControllers.last {
                currVC.hideBackBtn()
            }
        }
        vcToDisplay.prepareToDisplay(navigationController: self)
    }
}

public class UIOsNavigationViewControllerImpl: UIOsOrientationViewController {
    
    public static let sub1Size: CGFloat = 35
    public static let sub2Size: CGFloat = 18
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(false, animated: animated)
        if let navigationTitle = controller().navigationTitle {
            title = navigationTitle
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // only if clicked back
        if self.navigationController?.viewControllers.firstIndex(of: self) == nil {
            guard let navigator = navigationController,
                  let poppedVC = navigator.viewControllers.last,
                  let poppedVC = poppedVC as? UIOsNavigationViewController else {
                      return
                  }
            
            
            poppedVC.prepareToDisplay(navigationController: navigator)
        }
    }
    
    public override func orientationChangePhonePortrait() {
        _setNavigatoinTitle(fontSize: controller().navigationFontSizePhonePortrait)
    }
    
    public override func orientationChangePhoneLandscape() {
        _setNavigatoinTitle(fontSize: controller().navigationFontSizePhoneLandscape)
    }
    
    public override func orientationChangeiPadPortrait() {
        _setNavigatoinTitle(fontSize: controller().navigationFontSizeIpadPortrait)
    }
    
    public override func orientationChangeiPadLandscape() {
        _setNavigatoinTitle(fontSize: controller().navigationFontSizeIpadLandscape)
    }
    
    private func _setNavigatoinTitle(navigationController: UINavigationController? = nil, fontSize: CGFloat) {
        let font = controller().navigationTitleFont.withSize(fontSize)
        let color = controller().navigationFontColor
        let backgroundColor = controller().navigationBackgroundColor
        var _navigationController = navigationController
        if _navigationController == nil {
            _navigationController = self.navigationController!
        }
        _navigationController!.setTitleFontAndColor(font: font, color: color)
        _navigationController!.setBackgroundColor(color: backgroundColor)
    }
    
    /// Call to prepare this view controller for a push
    public func prepareToDisplay(navigationController: UINavigationController) {
        _ = storeNewOrientation()
        
        let device = Tools.getCurrentDevice()
        
        if Tools.isPortraitOrientation() {
            if device == .phone {
                _setNavigatoinTitle(navigationController: navigationController,
                                    fontSize: controller().navigationFontSizePhonePortrait)
            } else {
                _setNavigatoinTitle(navigationController: navigationController,
                                    fontSize: controller().navigationFontSizeIpadPortrait)
            }
        } else {
            if device == .phone {
                _setNavigatoinTitle(navigationController: navigationController,
                                    fontSize: controller().navigationFontSizePhoneLandscape)
            } else {
                _setNavigatoinTitle(navigationController: navigationController,
                                    fontSize: controller().navigationFontSizeIpadLandscape)
            }
        }
    }
    
    private func controller() -> UIOsNavigationViewController {
        self as! UIOsNavigationViewController
    }
}

public protocol OsNavigationViewControllerDelegate {
    
    /// Return false if you've put a custom back button image
    var navigationHideSystemBackBtn: Bool {set get}
    
    var navigationTitle: String? {set get}
    var navigationTitleFont: UIFont {set get}
    var navigationFontSizeIpadLandscape: CGFloat {set get}
    var navigationFontColor: UIColor {set get}
    var navigationFontSizeIpadPortrait: CGFloat {set get}
    var navigationFontSizePhonePortrait: CGFloat {set get}
    var navigationFontSizePhoneLandscape: CGFloat {set get}
    var navigationBackgroundColor: UIColor {set get}
}

/// An alias for forcing the child view controllers to implement all of the variables
public typealias UIOsNavigationViewController = UIOsNavigationViewControllerImpl & OsNavigationViewControllerDelegate

