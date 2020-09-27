//
//  ListPickerItem.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 24/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation

/// Will represent a single item in the list picker
public struct ListPickerItem {
    var title: String
    var tag: String?
    
    public init(title: String, tag: String? = nil) {
        self.tag = tag
        self.title = title
    }
    
}
