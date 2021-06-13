//
//  ListPicker.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 24/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation
import UIKit

public class ListPickerViewPopper {
    
    public static var shared = ListPickerViewPopper()
    var items: [ListPickerItem]?
    private var completion: ((ListPickerItem?) -> Void)? = nil
    
    // static finals
    public static let VIEW_TAG = 133
    
    private init(){}
    public func pop(parentView: UIView,
                    title: String,
                    items: [ListPickerItem]?,
                    _ completion: @escaping ((ListPickerItem?) -> Void)) {
        // build the dynamic view with all of the props
        self.items = items
        self.completion = completion
        let dv = UIDynamicView()
        dv.tag = ListPickerViewPopper.VIEW_TAG
        dv.prepareView(parentView: parentView,
                        padding: 15,
                        maxWidthPercentFromParent: 0.8)
        dv.dropShadow(shadowRadius: 5)
        
        // add the title
        let props = InitialLabelProps(text: title,
                                      textAlignment: .center,
                                      font: UIFont.systemFont(ofSize: 20, weight: .bold))
        dv.addView(initialProps: props)
        
        
        // set the inputs, one by one
        var btnProps: InitialButtonProps
        
        if let _items = items {
            for i in 0..._items.count - 1 {
                btnProps = InitialButtonProps(labelText: _items[i].title, alignment: .center, tapTarget: self, tapSelector: #selector(itemDidTap(_:)), font: UIFont.systemFont(ofSize: 19))
                dv.addView(initialProps: btnProps)
            }
        }
        
        btnProps = InitialButtonProps(labelText: "Dismiss", alignment: .right, tapTarget: self, tapSelector: #selector(dismissDidTap(_:)))
        dv.addView(initialProps: btnProps)
        dv.alpha = 0
        dv.attachView(parentView: parentView)
        dv.fadeIn {}
    }
    
    @objc func itemDidTap(_ sender: UIButton) {
        guard let chosenItem = items?.first(where: {$0.title == sender.titleLabel!.text}) else {return}
        if let parentView = sender.findParentBy(tag: ListPickerViewPopper.VIEW_TAG) {
            parentView.removeFromSuperview()
        }
        completion?(chosenItem)
        self.completion = nil
        self.items = nil
    }
    
    @objc func dismissDidTap(_ sender: UIButton) {
        if let parentView = sender.findParentBy(tag: ListPickerViewPopper.VIEW_TAG) {
            self.completion?(nil)
            parentView.removeFromSuperview()
            self.completion = nil
            self.items = nil
        }
    }
    
}


/// Will represent a single item in the list picker
open class ListPickerItem {
    public var tag: String?
    open var title: String!
    
    public init(title: String, tag: String? = nil) {
        self.tag = tag
        self.title = title
    }
}

