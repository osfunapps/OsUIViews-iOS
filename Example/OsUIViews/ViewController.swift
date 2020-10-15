//
//  ViewController.swift
//  UIDynamicView
//
//  Created by osfunapps on 08/18/2020.
//  Copyright (c) 2020 osfunapps. All rights reserved.
//

import UIKit
import OsTools
import OsUIViews

class ViewController: UIViewController {
    @IBOutlet var papaView: UIView!
    private var dv: UIDynamicView!
    
    @IBOutlet weak var dialogContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popDodo()
        Tools.asyncMainTimedFunc(raiseConstr, 2)
//        Tools.asyncMainTimedFunc(popFactsDialog, 2)
    }
    
    private func raiseConstr() {
        bottomConstr.constant = 30
        dv.updateHeight()
    }
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    private func popDodo() {
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        dv.prepareView(parentView: dialogContainer,
                       padding: 0,
                       sidesMargin: 12,
                       maxWidthPercentFromParent: 1.0)
        
//        dv.dropShadow(shadowRadius: 0)
        //        dv.scrollView.flashScrollIndicators()
        // add the title
            var props = InitialLabelProps(text: "bla",
                                          textAlignment: .center,
                                          font: UIFont.systemFont(ofSize: 20, weight: .bold))
            dv.addView(initialProps: props)
        
            props = InitialLabelProps(text: "Top explanation",
                                          textAlignment: .center,
                                          font: UIFont.systemFont(ofSize: 16))
            dv.addView(initialProps: props)
        
//            // add the video
//            let youtubeProps = InitialYoutubeVideoProps(videoId: "BywDOO99Ia0", alignment: .center)
//            dv.addView(initialProps: youtubeProps)
//
        // bottom explanation
            props = InitialLabelProps(text: "bottom explain", textAlignment: .left, font: UIFont.systemFont(ofSize: 14))
            dv.addView(initialProps: props)
        
        props = InitialLabelProps(text: """
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
bo sadasd dasadadsad sda sd as das asdttom explain
""", textAlignment: .left, font: UIFont.systemFont(ofSize: 14))
        dv.addView(initialProps: props)
        
//            let tfProps = InitialUITextFieldProps(approximateCharCount: 17,
//                                                  placeHolder: "00:00:00:00:00:00",
//                                                  alignment: .center,
//                                                  keyboardType: .namePhonePad,
//                                                  tag: 12,
//                                                  font: UIFont.systemFont(ofSize: 18, weight: .bold))
//        let v = dv.addView(initialProps: tfProps)
//
//
        let btnProps = InitialButtonProps(labelText: "Check and save", alignment: .center, tapSelector: #selector(onMacCheckTap), font: UIFont.systemFont(ofSize: 18, weight: .bold))
        dv.addView(initialProps: btnProps)
        
        
            let nextBtnProps = InitialButtonProps(labelText: "Next >",
                                              alignment: .right,
                                              tapSelector: #selector(onNextTap),
                                              font: UIFont.systemFont(ofSize: 18),
                                              tag: 50)
        
        dv.addView(initialProps: nextBtnProps)
        
        // if you can't find menus in the os, send us an email
        
        let TVprops = InitialLinkableUITextViewProps(fullText: "* If, for some reason, you can't find the option in your device, check out our Youtube channel for the newest guides. Furthermore, you can always reach us via email.",
                                                   textAlignment: .center,
                                                   font: UIFont.systemFont(ofSize: 13),
                                                   lineHeightMultiply: 1.25)
        
        let tv = dv.addView(initialProps: TVprops)
//        tv.addTopBorder(percentsFromWidth: 0.88)
        
        
        tv.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tv.setClickablePart(linkedText: "Youtube channel",
                            youtubeFullLink: "https://www.youtube.com/channel/UCBvgqUEIxJHR7o2q3CJ-4Wg")
        
        tv.setClickablePart(linkedText: "via email",
                            emailRecipient: "support@os-apps.com",
                            emailSubject: "a problem with an iOS app")
        
        //        v.setHeight(height: 150)
        //        v.refreshLayout()
        
        dv.alpha = 0
        dv.isUserInteractionEnabled = true
        dv.attachView(parentView: dialogContainer,
                      toParentTopSafeArea: true,
                      toParentBottomSafeArea: true,
                      preventInteractionWithOtherViews: true)
//
        dv.fadeIn {
            
        }
    }
    
    @objc func onMacCheckTap() {
        
    }
    
    @objc func onNextTap() {
        
    }
    private func popFactsDialog() {
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        dv.prepareView(parentView: view,
                       padding: 14,
                       maxWidthPercentFromParent: 0.65)
        dv.dropShadow(shadowRadius: 5.0)
        
//        // add the title
        let topTitleProps = InitialLabelProps(text: "New Features",
                                              textAlignment: .center,
                                              font: UIFont.systemFont(ofSize: 20, weight: .bold))
        dv.addView(initialProps: topTitleProps)

//        let props = InitialLinkableUITextViewProps(fullText: "what is the time", textAlignment: .center, tag: 9, isEditable: false)
        let props = InitialLinkableUITextViewProps(fullText: "* If, for some reason, you can't find the option in your device, check out our Youtube channel at https://www.youtube.com/channel/UCBvgqUEIxJHR7o2q3CJ-4Wg for the newest guides. Furthermore, you can reach us via email at support@os-apps.com", textAlignment: .center, font: UIFont.systemFont(ofSize: 15), lineHeightMultiply: 1.5)
//
        let tv = dv.addView(initialProps: props)
        tv.setClickablePart(linkedText: "If, for some reason", youtubeFullLink: "youtube://www.youtube.com/channel/UCBvgqUEIxJHR7o2q3CJ-4Wg")
        tv.setClickablePart(linkedText: "find the option", emailSubject: "what is")
//        // add the image
//        let imgProps = InitialUIImageViewProps(imageName: "tt",
//                                               widthPercentFromParent: 0.3,
//                                               tag: 99,
//                                               alignment: .center)
//        dv.addView(initialProps: imgProps)
//
//        // add the description
//        let descriptionProps =  InitialLabelProps(text:
//            """
//            Teletubbies is a British children's television series
//            created by Ragdoll Productions' Anne Wood and Andrew
//            Davenport for BBC.
//            """,
//            textAlignment: .left,
//            font: UIFont.systemFont(ofSize: 17)
//        )
//        dv.addView(initialProps: descriptionProps)
//
//        // add the footer buttons
//        let nextFactButton = InitialButtonProps(labelText: "Previous Fact",
//        alignment: .left,
//        tapSelector: #selector(onNextFactTap))
//
//        let niceBtn = InitialButtonProps(labelText: "Next Fact!",
//                                             alignment: .right,
//                                             tapSelector: #selector(onNiceTap))
//        let footerStackViewProps = InitialStackViewProps(subviewsInitialPropsList: [nextFactButton, niceBtn])
//
//        dv.addView(initialProps: footerStackViewProps)
        dv.attachView(parentView: view)
    }
    
    private func popHelpDialog() {
        
        
        // prepare the dialog
        let dialogWrapper = UIDialogWrapper(parentView: view, margin: 20, maxWidthPercentFromParent: 0.85)
        
        // set title and description
        dialogWrapper.setTitle(text: "Turn on your TV", size: 18)
        dialogWrapper.setTopDesription(text: """
                   In the future, allow this TV to be turned on by the phone
                   """, size: 16)
        dialogWrapper.setFooter(leftBtnText: "Later",
                                rightBtnText: "Allow",
                                leftBtnTapSelector: #selector(onNiceTap),
                                rightBtnTapSelector: #selector(onNextFactTap))
        
        // attach the view to it's parent
        dialogWrapper.attachView(parentView: view)
        
//        // build the dynamic view with all of the props
//        dv = UIDynamicView()
//        dv.prepareView(parentView: view,
//                       padding: 14,
//                       margin: 14,
//                       maxWidthPercentFromParent: 0.65)
//        dv.dropShadow(shadowRadius: 5.0)
//
//        // add the title
//        let topTitleProps = InitialLabelProps(text: "Help",
//                                              textAlignment: .center,
//                                              font: UIFont.systemFont(ofSize: 20, weight: .bold))
//        dv.addView(initialProps: topTitleProps)
//
//        // add the description
//        let descriptionProps =  InitialLabelProps(text:
//            """
//            Please watch the below video to understand how to use the app
//            """,
//            textAlignment: .left,
//            font: UIFont.systemFont(ofSize: 19)
//        )
//        dv.addView(initialProps: descriptionProps)
//
//        // add the youtube video
//        let videoProps = InitialYoutubeVideoProps(videoId: "BywDOO99Ia0",
//                                                  widthPercentFromParent: 0.75,
//                                                  alignment: .center)
//        dv.addView(initialProps: videoProps)
//
//        // add the footer button
//        let okBtnProps = InitialButtonProps(labelText: "OK",
//        alignment: .right,
//        tapSelector: #selector(onOkBtnTap))
//
//        dv.addView(initialProps: okBtnProps)
//        dv.attachView(parentView: view)
    }
    
    @objc func onNiceTap() {
        print("nice!")
    }
    
    @objc func onNextFactTap() {
        print("next!")
    }
    
    @objc func onOkBtnTap() {
        dv.fadeOut {
            self.dv.removeFromSuperview()
        }
    }
}

