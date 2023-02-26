//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation
import UIKit

/// Use this class if you want to set an attributed text to a textview with custom actions on certain text. For example, if you want the text to be "this is some text and this is some clickable text" and you want the clickable
/// text to be clickable and open custom action, use this class
///
/// To use this class, create it and call setAttrbiutedText()
///
public class UIClickableTextView: UITextView {
    
    // indications
    public var clickableTextDidTap: ((String) -> ())? = nil
    
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isEditable = false
        isSelectable = true
        delegate = self
    }
}

extension UIClickableTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        var string = URL.absoluteString
        string = string.removingPercentEncoding!
        clickableTextDidTap?(string)
        return false
    }
}


