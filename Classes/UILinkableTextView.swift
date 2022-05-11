//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation

/// This class represents a UITextView but can act as a UILabel.
/// Use this UIView if you want to implement a text with certain link areas like: If you want to contact us, click here) and a tap on the "here" text will do something.4
/// To use the class call setText and then setClickablePart with the text you want to make a link and the action attached to the text
/// NOTICE: If you want custom action for a click on certain text, use UIClickableTextView
public class UILinkableTextView: UITextView {

    /// change to set each of the clickable link props
    public var clickableLinkFont: UIFont = .systemFont(ofSize: 15)
    public var clickableLinkColor: UIColor = .blue
    
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
    }
    
    /// Will set the initial text here. Call this function to set all of the text you want in the view. Then, call setClickableText() to decide which is clickable
    public func setText(text: String,
                        lineHeightMultiple: CGFloat = 1,
                        font: UIFont = .systemFont(ofSize: 15),
                        _ completion: (() -> Void)? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.font] = font
        DispatchQueue.main.async {
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
            completion?()
        }
    }
    
    /// Call this function after you set the text using setText. Decide which part of the text will navigate to a specific youtube url.
    /// youtubeUrl: "https://www.youtube.com/watch?v=5qap5aO4i9A" or even "https://www.youtube.com/channel/UCSJ4gkVC6NrvII8umztf0Ow"
    public func setClickablePart(linkedText: String, youtubeFullLink: String) {
        var youtubeLink = youtubeFullLink
        youtubeLink.removePrefix("https://")
        youtubeLink.removePrefix("http://")
        let url = URL(string: "youtube://\(youtubeLink)")!
        setClickableRange(url: url, linkedText: linkedText)
    }
    
    /// Call this function after you set the text using setText. Decide which part of the text will navigate to a location decided by the OS. Most of the times it will just use Safari
    public func setClickablePart(linkedText: String, link: String) {
        let url = URL(string: link)!
        setClickableRange(url: url, linkedText: linkedText)
    }
    
    /// Call this function after you set the text using setText. Decide which part of the text will navigate to an email message with receipients
    public func setClickablePart(linkedText: String,
                                 emailRecipient: String = "",
                                 cc: [String]? = nil,
                                 emailSubject: String = "",
                                 emailContent: String = ""
    ) {
        var recipients = ""
        if let _cc = cc {
            recipients = _cc.joined(separator: ",")
        }
        let ans = "mailto:\(emailRecipient)?cc=\(recipients)&subject=\(emailSubject)&body=\(emailContent)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: ans)!
        setClickableRange(url: url, linkedText: linkedText)
    }
    
    private func setClickableRange(url: URL, linkedText: String) {
        guard let range = self.text.range(of: linkedText) else {return}
        
        let newAttText = attributedText.mutableCopy() as! NSMutableAttributedString
        newAttText.addAttributes([.link: url,
                                  .font: clickableLinkFont],
                                 range: NSRange(range, in: text))
        linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: clickableLinkColor,
            
            // disable for cancelling underline for the link
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedText = newAttText
    }
    
}
