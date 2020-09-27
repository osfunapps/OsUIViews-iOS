//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation

/// This class represents a UITextView but can act as a UILabel.
/// Use this UIView if you want to implement a text with certain link areas like: If you want to contact us, click here) and a tap on the "here" text will do something
public class LinkableUITextView: UITextView {

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
    }
    
    /// Will set the initial text here. Call this function to set all of the text you want in the view. Then, call setClickableText() to decide which is clickable
    public func setText(text: String, lineHeightMultiple: CGFloat = 1) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    /// Call this function after you set the text using setText. Decide which part of the text will navigate to a specific youtube url.
    /// youtubeUrl: "https://www.youtube.com/watch?v=5qap5aO4i9A" or even "https://www.youtube.com/channel/UCSJ4gkVC6NrvII8umztf0Ow"
    public func setClickablePart(linkedText: String, youtubeFullLink: String) {
        var youtubeLink = youtubeFullLink
        youtubeLink.removePrefix("https://")
        youtubeLink.removePrefix("http://")
        let url = URL(string: "youtube://\(youtubeLink)")!
        guard let range = self.text.range(of: text) else {return}
        
        let newAttText = attributedText.mutableCopy() as! NSMutableAttributedString
        newAttText.setAttributes([.link: url], range: NSRange(range, in: text))
        attributedText = newAttText
    }
    
    /// Call this function after you set the text using setText. Decide which part of the text will navigate to an email message with receipients
    public func setClickablePart(linkedText: String,
                                 emailRecipient: String = "",
                                 emailSubject: String = "",
                                 cc: [String]? = nil) {
        var recipients = ""
        if let _cc = cc {
            recipients = _cc.joined(separator: ",")
        }
        let url = URL(string: "mailto:\(emailRecipient)?cc=\(recipients)&subject=\(emailSubject)")!
        guard let range = self.text.range(of: text) else {return}
        
        let newAttText = attributedText.mutableCopy() as! NSMutableAttributedString
        newAttText.setAttributes([.link: url], range: NSRange(range, in: text))
        attributedText = newAttText
    }
    
    
}
