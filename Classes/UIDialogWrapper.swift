//
//  UIDialogWrapper.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 18/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper
public class UIDialogWrapper {
    
    // views
    private var dynamicContainer: UIDynamicView? = nil
    
    // constants
    public static let TAG_TITLE_VIEW = 90
    public static let TAG_TOP_DESCRIPTION_VIEW = 91
    public static let TAG_BOTTOM_DESCRIPTION_VIEW = 92
    public static let TAG_INPUT_VIEW = 93
    public static let TAG_IMAGE_VIEW = 94
    public static let TAG_YOUTUBE_VIEW = 95
    public static let TAG_LEFT_BUTTON_VIEW = 96
    public static let TAG_RIGHT_BUTTON_VIEW = 97
    public static let TAG_BUTTONS_STACK_VIEW = 98
    
    public init(parentView: UIView,
                padding: CGFloat = UIDynamicView.DEF_PADDING,
                sidesMargin: CGFloat = UIDynamicView.DEF_MARGIN,
                bottomMargin: CGFloat = 0,
                topMargin: CGFloat = 0,
                maxWidthPercentFromParent: CGFloat = 1.0,
                viewTag: Int = 0) {
        dynamicContainer = UIDynamicView()
        dynamicContainer!.prepareView(parentView: parentView,
                                      padding: padding,
                                      sidesMargin: sidesMargin,
                                      bottomMargin: bottomMargin,
                                      topMargin: topMargin,
                                      maxWidthPercentFromParent: maxWidthPercentFromParent)
        dynamicContainer!.tag = viewTag
    }
    
    /// Will change the background color of the dialog
    public func setBackgroundColor(color: UIColor) {
        dynamicContainer?.setBackgroundColor(color: color)
    }
    
    public func setTag(viewTag: Int) {
        dynamicContainer?.tag = viewTag
    }
    
    public func setTitle(text: String, font: UIFont = UIFont.boldSystemFont(ofSize: 27)) {
        let initialProps = InitialLabelProps(text: text,
                                             textAlignment: .center,
                                             numberOfLines: 1,
                                             tag: UIDialogWrapper.TAG_TITLE_VIEW,
                                             font: font,
                                             lineHeightMultiply: 1)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setTopDescription(text: String, font: UIFont = UIFont.systemFont(ofSize: 16)) {
        setDescription(text: text, font: font, tag: UIDialogWrapper.TAG_TOP_DESCRIPTION_VIEW)
    }
    
    public func setBottomDescription(text: String, font: UIFont = UIFont.systemFont(ofSize: 15)) {
        setDescription(text: text, font: font, tag: UIDialogWrapper.TAG_BOTTOM_DESCRIPTION_VIEW)
    }
    
    private func setDescription(text: String, font: UIFont, tag: Int) {
        let initialProps = InitialLabelProps(text: text,
                                             textAlignment: .left,
                                             numberOfLines: 0,
                                             tag: tag,
                                             font: font,
                                             lineHeightMultiply: 1.5)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    /// You should call this function if there is a change in the height of the parent view (if you're adding ads, for example) after the view has already been inflated
    public func updateHeight() {
        dynamicContainer?.updateHeight()
    }
    
    
    public func setImageView(imageName: String, widthPercentFromParent: CGFloat = 1.0) {
        let initialProps = InitialUIImageViewProps(imageName: imageName,
                                                   widthPercentFromParent: widthPercentFromParent,
                                                   tag: UIDialogWrapper.TAG_IMAGE_VIEW,
                                                   alignment: .center)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setYoutubeVideo(videoId: String, widthPercentFromParent: CGFloat = 1.0, heightPercentFromWidth: CGFloat = 0.5) {
        let initialProps = InitialYoutubeVideoProps(videoId: videoId,
                                                    widthPercentFromParent: widthPercentFromParent,
                                                    heightPercentFromWidth: heightPercentFromWidth,
                                                    tag: UIDialogWrapper.TAG_YOUTUBE_VIEW,
                                                    alignment: .center)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setFooter(leftBtnText: String? = nil,
                          leftBtnTapTarget: Any? = nil,
                          leftBtnTapSelector: Selector? = nil,
                          rightBtnText: String? = nil,
                          rightBtnTapTarget: Any?,
                          rightBtnTapSelector: Selector? = nil) {
        
        var initialBtnsPropList = [InitialButtonProps]()
        if let _leftBtnText = leftBtnText, let _leftBtnTapSelector = leftBtnTapSelector {
            let leftBtnProps = InitialButtonProps(labelText: _leftBtnText,
                                                  alignment: .left,
                                                  tapTarget: leftBtnTapTarget,
                                                  tapSelector: _leftBtnTapSelector,
                                                  tag: UIDialogWrapper.TAG_LEFT_BUTTON_VIEW)
            initialBtnsPropList.append(leftBtnProps)
        }
        
        if let _rightBtnText = rightBtnText, let _rightBtnTapSelector = rightBtnTapSelector {
            let rightBtnProps = InitialButtonProps(labelText: _rightBtnText,
                                                   alignment: .right,
                                                   tapTarget: rightBtnTapTarget,
                                                   tapSelector: _rightBtnTapSelector,
                                                   tag: UIDialogWrapper.TAG_RIGHT_BUTTON_VIEW)
            initialBtnsPropList.append(rightBtnProps)
        }
        
        
        if !initialBtnsPropList.isEmpty {
            let svInitialProps = InitialStackViewProps(subviewsInitialPropsList: initialBtnsPropList,
                                                       tag: UIDialogWrapper.TAG_BUTTONS_STACK_VIEW)
            dynamicContainer!.addView(initialProps: svInitialProps)
        }
        
    }
    
    // dialog wrapper changed
    public func setInputField(placeHolder: String,
                              approximateCharCount: Int,
                              keyboardType: UIKeyboardType = .default,
                              font: UIFont = UIFont.systemFont(ofSize: 17),
                              autoCorrect: UITextAutocorrectionType = .default) {
        let initialProps = InitialUITextFieldProps(approximateCharCount: approximateCharCount,
                                                   placeHolder: placeHolder,
                                                   alignment: .center,
                                                   keyboardType: keyboardType,
                                                   tag: UIDialogWrapper.TAG_INPUT_VIEW,
                                                   font: font,
                                                   autoCorrect: autoCorrect)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func attachView(parentView: UIView,
                           toParentTopSafeArea: Bool = true,
                           toParentBottomSafeArea: Bool = true,
                           preventInteractionWithOtherViews: Bool = true) {
        dynamicContainer!.attachView(parentView: parentView,
                                     toParentTopSafeArea: toParentTopSafeArea, toParentBottomSafeArea: toParentBottomSafeArea, preventInteractionWithOtherViews: preventInteractionWithOtherViews)
    }
    
    // TODO: control the fade out duration
    public func dismiss() {
        dynamicContainer?.fadeOut {
            self.dynamicContainer?.removeFromSuperview()
            self.dynamicContainer = nil
        }
    }
    
    
    // MARK: - getters
    public func getTitleLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_TITLE_VIEW) as? UILabel
    }
    
    public func getTopDescriptionLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_TOP_DESCRIPTION_VIEW) as? UILabel
    }
    
    public func getBottomDescriptionLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_BOTTOM_DESCRIPTION_VIEW) as? UILabel
    }
    
    public func getInputTextField() -> UITextField? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_INPUT_VIEW) as? UITextField
    }
    
    public func getImageView() -> UIImageView? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_IMAGE_VIEW) as? UIImageView
    }
    
    public func getLeftButton() -> UIButton? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_LEFT_BUTTON_VIEW) as? UIButton
    }
    
    public func getRightButton() -> UIButton? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_RIGHT_BUTTON_VIEW) as? UIButton
    }
    
    public func getYoutubeView() -> YTPlayerView? {
        return dynamicContainer!.viewWithTag(UIDialogWrapper.TAG_YOUTUBE_VIEW) as? YTPlayerView
    }
        
}
