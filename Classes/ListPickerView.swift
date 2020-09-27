//
//  ListPicker.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 24/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation
import UIKit

public class ListPickerView {
    
    private var delegate: ListPickerViewDelegate?
    private var dv: UIDynamicView?
    private var items: [ListPickerItem]?
    
    public init(){}
    public func pop(delegate: ListPickerViewDelegate, parentView: UIView, title: String, lst: [ListPickerItem]) {
        self.delegate = delegate
        self.items = lst
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        
        dv!.prepareView(parentView: parentView,
                        padding: 15,
                        maxWidthPercentFromParent: 0.8)
        dv!.dropShadow(shadowRadius: 5)
        
        // add the title
        let props = InitialLabelProps(text: title,
                                      textAlignment: .center,
                                      font: UIFont.systemFont(ofSize: 20, weight: .bold))
        dv!.addView(initialProps: props)
        
        
        // set the inputs, one by one
        var btnProps: InitialButtonProps
        
        for i in 0...lst.count - 1 {
            btnProps = InitialButtonProps(labelText: lst[i].title, alignment: .center, tapSelector: #selector(onItemTap(_:)), tapTarget: self, font: UIFont.systemFont(ofSize: 19))
            dv!.addView(initialProps: btnProps)
        }
        
        btnProps = InitialButtonProps(labelText: "Dismiss", alignment: .right, tapSelector: #selector(onDismissTap(_:)), tapTarget: self)
        dv!.addView(initialProps: btnProps)
        dv!.alpha = 0
        dv!.attachView(parentView: parentView)
        dv!.fadeIn {}
    }
    
    @objc func onItemTap(_ sender: UIButton) {
        guard let chosenItem = items?.first(where: {$0.title == sender.titleLabel!.text}) else {return}
        self.delegate?.onPickerItemSelected(item: chosenItem)
    }
    
    @objc func onDismissTap(_ sender: UIButton) {
        dv?.removeFromSuperview()
        self.delegate?.onPickerDismissed()
    }
    
}

public protocol ListPickerViewDelegate {
    func onPickerItemSelected(item: ListPickerItem)
    func onPickerDismissed()
}

public extension ListPickerViewDelegate {
    func onPickerItemSelected(item: ListPickerItem){}
    func onPickerDismissed(){}
}
