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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tools.asyncMainTimedFunc(popFactsDialog, 2)
        
//        tv.setText(text: "wjat is the time")
//        tv.setClickablePart(linkedText: "wjat", youtubeFullLink: "youtube://www.youtube.com/channel/UCBvgqUEIxJHR7o2q3CJ-4Wg")
        
//        let tv = LinkableUITextView()
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.setHeight(height: 150)
//        tv.setWidth(width: 250)
//        papaView.addSubview(tv)
//        tv.centralizeVerticalInParent()
//        tv.centralizeHorizontalInParent()
//        tv.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
////        tv.setText(text: "what is the time???")
    }
    
    private var dv: UIDynamicView!
    
    private func popFactsDialog() {
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        dv.prepareView(parentView: view,
                       padding: 14,
                       margin: 14,
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
        tv.setClickablePart(linkedText: "find the option", emailRecipient: "ozshabat@gmail.com", emailSubject: "what")
        tv.setClickablePart(linkedText: "for the newest guides", link: "https://www.google.com")
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

