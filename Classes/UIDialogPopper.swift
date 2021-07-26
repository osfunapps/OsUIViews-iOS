//
//  UIDialogPopper.swift
//  BuildDynamicUi
//
//  Created by Oz Shabat on 12/01/2019.
//  Copyright © 2019 osApps. All rights reserved.
//

import UIKit

// This class will pop a simple dialogs (choice, information, etc)
public class UIDialogPopper {
    
    /// Will pop an information dialog with one button
    public static func popInformationDialog(_ viewController: UIViewController,
                                      title: String = "",
                                      msg: String = "",
                                      btnTitle: String = "Ok",
                                      dismissOnBtnTap: Bool = true,
                                      btnDidTap: @escaping (() -> Void) = { }){
        
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: { action in
            btnDidTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Will pop a choice dialog  (two buttons dialog)
    public static func popChoiceDialog(viewController: UIViewController,
                                      title: String = "",
                                      msg: String = "",
                                      proceedBtnTitle: String = "Proceed",
                                      cancelBtnTitle: String = "Cancel",
                                      dismissOnBtnTap: Bool = true,
                                      cancelDidTap: @escaping (() -> Void) = { },
                                      proceedDidTap: @escaping (() -> Void) = { }){
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: proceedBtnTitle, style: .destructive , handler: { action in
            proceedDidTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: { action in
            cancelDidTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Will pop an input dialog (a dailog with an input field, cancel and submit)
    public static func popInputDialog(viewController: UIViewController,
                                      title: String = "",
                                      msg: String = "",
                                      submitBtnTitle: String = "Submit",
                                      cancelBtnTitle: String = "Cancel",
                                      inputPlaceHolder: String = "",
                                      dismissOnBtnTap: Bool = true,
                                      cancelDidTap: @escaping (() -> Void) = { },
                                      submitDidTap: @escaping ((String?) -> Void)){
        
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = inputPlaceHolder
        }
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: submitBtnTitle, style: .destructive , handler: { action in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            submitDidTap(textField.text)
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: { action in
            cancelDidTap()
            if dismissOnBtnTap {
                alert.dismiss(animated: true)
            }
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
