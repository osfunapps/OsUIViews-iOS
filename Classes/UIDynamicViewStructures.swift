//
//  UIDynamicViewStructures.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 18/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// Will create a struct containing the initial props for a UILabel
public struct InitialLabelProps: InitialProps {
    
    var text: String
    var textAlignment: UIViewAlignment
    var numberOfLines: Int
    var tag: Int
    var font: UIFont
    var lineHeightMultiply: CGFloat
    var textColor: UIColor?
    
    public init(text: String,
                textAlignment: UIViewAlignment = .center,
                textColor: UIColor? = nil,
                numberOfLines: Int = 0,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17),
                lineHeightMultiply: CGFloat = 1.25) {
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.textColor = textColor
        self.tag = tag
        self.font = font
        self.lineHeightMultiply = lineHeightMultiply
    }
    public func getType() -> UIViewType {
        return .label
    }
}

/// Will create a struct containing the initial props for a LinkableUITextView.
/// a LinkableUITextView is a UITextView with the ability to make a text clickable and navigate to a certain apps (intent) using URLSchemes.
/// NOTICE: in order to make the text clickable, initially set the full text you want to be shown in UITextView. Later, after adding the view to the parent,
///  call view.setClickablePart() to set the clickable part. Also, if you get a layer exception, give original name for the variable and not just "view": let view = InitialLinkableUITextViewProps()"
public struct InitialUILinkableTextViewProps: InitialProps {
    
    var fullText: String
    var textAlignment: UIViewAlignment
    var tag: Int
    var font: UIFont
    var lineHeightMultiply: CGFloat
    var isEditable: Bool
    var textColor: UIColor?
    
    public init(fullText: String,
                textAlignment: UIViewAlignment = .center,
                textColor: UIColor? = nil,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17),
                lineHeightMultiply: CGFloat = 1.25,
                isEditable: Bool = false) {
        self.fullText = fullText
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.tag = tag
        self.font = font
        self.lineHeightMultiply = lineHeightMultiply
        self.isEditable = isEditable
    }
    public func getType() -> UIViewType {
        return .linkableTextView
    }
}


/// Will create a struct containing the initial props for a UITextField
public struct InitialUITextFieldProps: InitialProps {
    
    var approximateCharCount: Int
    var placeHolder: String
    var backgroundColor: UIColor
    var textColor: UIColor
    var alignment: UIViewAlignment
    var keyboardType: UIKeyboardType
    var tag: Int
    var font: UIFont
    var autoCorrect: UITextAutocorrectionType
    
    public init(approximateCharCount: Int,
                placeHolder: String,
                backgroundColor: UIColor = .white,
                textColor: UIColor = .black,
                alignment: UIViewAlignment = .center,
                keyboardType: UIKeyboardType = .default,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17),
                autoCorrect: UITextAutocorrectionType = .default) {
        self.approximateCharCount = approximateCharCount
        self.placeHolder = placeHolder
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.alignment = alignment
        self.keyboardType = keyboardType
        self.tag = tag
        self.font = font
        self.autoCorrect = autoCorrect
    }
    
    public func getType() -> UIViewType {
        return .textField
    }
}



/// Will create a struct containing the initial props for a UIImageView
public struct InitialUIImageViewProps: InitialProps {
    var imageName: String
    var widthPercentFromParent: CGFloat
    var tag: Int
    var alignment: UIViewAlignment
    
    public init(imageName: String,
                widthPercentFromParent: CGFloat = 1.0,
                tag: Int = 0,
                alignment: UIViewAlignment = .center) {
        self.imageName = imageName
        self.widthPercentFromParent = widthPercentFromParent
        self.tag = tag
        self.alignment = alignment
    }
    
    public func getType() -> UIViewType {
        return .imageView
    }
}

/// Will create a struct containing the initial props for a YoutubeVideo
public struct InitialYoutubeVideoProps: InitialProps {
    
    var videoId: String
    var widthPercentFromParent: CGFloat
    var heightPercentFromWidth: CGFloat
    var tag: Int
    var alignment: UIViewAlignment
    
    public init(videoId: String,
                widthPercentFromParent: CGFloat = 1.0,
                heightPercentFromWidth: CGFloat = 1.0,
                tag: Int = 0,
                alignment: UIViewAlignment = .center) {
        self.videoId = videoId
        self.widthPercentFromParent = widthPercentFromParent
        self.heightPercentFromWidth = heightPercentFromWidth
        self.tag = tag
        self.alignment = alignment
    }
    
    public func getType() -> UIViewType {
        return .youtubeVideo
    }
}

/// Will create a struct containing the initial props for a UIButton
public struct InitialButtonProps: InitialProps {
    
    var labelText: String
    var alignment: UIViewAlignment
    var tapSelector: Selector
    var tapTarget: Any?
    var font: UIFont
    var tag: Int
    var textColor: UIColor?
    
    public init(labelText: String,
                alignment: UIViewAlignment = .center,
                tapTarget: Any? = nil,
                textColor: UIColor? = nil,
                tapSelector: Selector,
                font: UIFont = UIFont.systemFont(ofSize: 15),
                tag: Int = 0) {
        self.labelText = labelText
        self.alignment = alignment
        self.textColor = textColor
        self.tapSelector = tapSelector
        self.tapTarget = tapTarget
        self.tag = tag
        self.font = font
    }
    
    public func getType() -> UIViewType {
        return .button
    }
}

/// Will create a struct containing the initial props for a UIStackView
public struct InitialStackViewProps: InitialProps {
    
    /// Will hold a list of all of the initial properties for the stack view's subviews. For example: [InitialButtonProps.init(), InitialLabelProps.init(), etc...]
    var subviewsInitialPropsList: [InitialProps]
    
    var spacing: CGFloat
    var axis: NSLayoutConstraint.Axis
    var distribution: UIStackView.Distribution
    var tag: Int
    
    public init(subviewsInitialPropsList: [InitialProps],
                spacing: CGFloat = 10,
                axis: NSLayoutConstraint.Axis = .horizontal,
                distribution: UIStackView.Distribution = .equalSpacing,
                tag: Int = 0) {
           self.subviewsInitialPropsList = subviewsInitialPropsList
           self.spacing = spacing
           self.axis = axis
           self.distribution = distribution
           self.tag = tag
       }
       
    
    public func getType() -> UIViewType {
        return .stackView
    }
}


public protocol InitialProps {
    func getType() -> UIViewType
}

public enum UIViewType {
    case label
    case textField
    case imageView
    case youtubeVideo
    case button
    case stackView
    case linkableTextView
}

public enum UIViewAlignment {
    case left
    case center
    case right
}

