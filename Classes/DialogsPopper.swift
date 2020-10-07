//
//  LoadingDialogPopper.swift
//  BuildDynamicUi
//
//  Created by Oz Shabat on 12/01/2019.
//  Copyright © 2019 osApps. All rights reserved.
//

import UIKit

// This class will pop a simple dialogs (choice, information, etc)
class DialogsPopper {
    
    /// Will pop an information dialog with one button
    static func showInformationDialog(_ viewController: UIViewController,
                                      title: String = "",
                                      msg: String = "",
                                      btnTitle: String = "Ok",
                                      dismissOnBtnTap: Bool = true,
                                      completion: @escaping (() -> Void) = { }){
        
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: { action in
            completion()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Will pop a choice dialog  (two buttons dialog)
    static func popChoiceDialog(viewController: UIViewController,
                                      title: String = "",
                                      msg: String = "",
                                      proceedBtnTitle: String = "Proceed",
                                      cancelBtnTitle: String = "Cancel",
                                      dismissOnBtnTap: Bool = true,
                                      onCancelTap: @escaping (() -> Void) = { },
                                      onProceedTap: @escaping (() -> Void) = { }){
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: proceedBtnTitle, style: .destructive , handler: { action in
            onProceedTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: { action in
            onCancelTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
