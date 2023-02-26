//
//  AttributedUILabel.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 23/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import Foundation
import UIKit

/// Use this label if you want a label with different colors to it's text.
/// You can do the same from the Inspector Builder AttributedText BUT you can't get the colors there from a resouce, which is pretty shitty.
///
/// To use:
/// 1) Make sure you set the text to Attributed, set your text there
/// 2) Add the sentences you would like to color in coloredSentences. Make sure you separate each statement to color in the required separator
/// 3) Set the color you wish to use in coloredTextColor
///
public class UIColorableLabel: UILabel {
    
    public static let COLORED_SENTENCES_SEPARATOR: Character = "#"
    
    /// Set here the sentences you would like to paint in a different color.
    /// Separate each sentence with # like: this is the first sentence#This is the second one!
    @IBInspectable public var coloredSentences: String? = nil {
        didSet {
            refreshSentences()
        }
    }
    
    /// Set here the color which will be used to color your desired text
    @IBInspectable public var coloredTextColor: UIColor = .black {
        didSet {
            refreshSentences()
        }
    }
    
    /// Set here the color you want for all of the other text.
    /// It means to serve as a way to set a color from a resource, which the attributed text doesn't support natively
    @IBInspectable public var generalTextColor: UIColor = .black {
        didSet {
            paintAllText(color: generalTextColor)
            refreshSentences()
        }
    }
    
    private func refreshSentences() {
        guard let sentences = coloredSentences else {return}
        let sentencesList = sentences.split(separator: UIColorableLabel.COLORED_SENTENCES_SEPARATOR)
        guard sentencesList.count > 0,
              var updatedAttributedText = attributedText else {return}
        
        text = nil
        sentencesList.forEach { it in
            updatedAttributedText = findAndColorSentence(attribText: updatedAttributedText,
                                                         sentence: String(it),
                                                         color: coloredTextColor)
        }
    }
    
    private func findAndColorSentence(attribText: NSAttributedString, sentence: String, color: UIColor) -> NSAttributedString {
        let nsRange = NSString(string: attribText.string).range(of: sentence, options: String.CompareOptions.caseInsensitive)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attribText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: color, range: nsRange)
        
        attributedText = mutableAttributedString
        return mutableAttributedString
    }
    
    private func paintAllText(color: UIColor) {
        guard let attribText = attributedText else {return}
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attribText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: color,
                                             range: NSRange.init(0...attribText.string.count-1))
        
        attributedText = mutableAttributedString
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        refreshSentences()
    }
}
