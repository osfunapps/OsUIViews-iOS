//
//  SelfSignedView.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 12/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import OsTools

/// Represents a dynamic view to be structured from code
public class UIDynamicView: UIView {
    
    /// The view which holds all of the added views
    @IBOutlet public weak var viewsContainer: UIView!
    @IBOutlet public weak var scrollView: UIScrollView!
    @IBOutlet private var contentView: UIView!
    
    /// The scroll view holder
    @IBOutlet weak var scrollViewParentView: UIView!
    @IBOutlet weak var containerViewTopConstr: NSLayoutConstraint!
    
    // indications
    public var padding: CGFloat!
    public var topMargin: CGFloat!
    public var bottomMargin: CGFloat!
    public var sidesMargin: CGFloat!
    var toParentTopSafeArea = false
    var toParentBottomSafeArea = false
    public var spaceBetweenViews = DEF_SPACE_BETWEEN_VIEWS
    private var maxInnerSize: CGFloat = 0
    private var latestViewAdded: UIView? = nil
    private var containerViewTopConstrConst: CGFloat = 0
    private var siblingViewsInteractable = true
    private var preventClicksOnOtherViews = false
    private var viewsContainerBottomConstr: NSLayoutConstraint? = nil
    private var currViewsContainerWidth: CGFloat = 0
    private var currViewsContainerHeight: CGFloat = 0
    private var viewsContainerWidthConstr: NSLayoutConstraint = NSLayoutConstraint()
    private var viewsContainerHeightConstr: NSLayoutConstraint = NSLayoutConstraint()
    private var maxViewsContainerWidth: CGFloat!
    var viewDistanceFromTop: CGFloat?
    
    // constants
    public static let DEF_PADDING: CGFloat = 14
    public static let DEF_MARGIN: CGFloat = 14
    private static let DEF_SPACE_BETWEEN_VIEWS: CGFloat = 10
    private let DEF_USER_TF_CHAR_COUNT: Int = 30
    private let CONSTRAINT_WIDTH_ID = "width"
    
    
    /// Will prepare the view for first init. Call this method on startup
    ///
    /// - Parameter parentView: The parent view to attach to
    /// - Parameter padding: The spacing between the frame to the inner views
    /// - Parameter margin: The spacing between the view to it's parent
    /// - Parameter maxWidthPercentFromParent: The maximum width of the view, related to it's parent view
    public func prepareView(parentView: UIView,
                            padding: CGFloat = DEF_PADDING,
                            sidesMargin: CGFloat = DEF_MARGIN,
                            bottomMargin: CGFloat = 0,
                            topMargin: CGFloat = 0,
                            maxWidthPercentFromParent: CGFloat = 1.0) {
        self.padding = padding
        self.sidesMargin = sidesMargin
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        parentView.refreshLayout()
        maxViewsContainerWidth = (parentView.frame.width) * maxWidthPercentFromParent - sidesMargin * 2
        maxInnerSize = maxViewsContainerWidth - padding * 2
        currViewsContainerHeight = padding
    }
    
    
    /// init option 1
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// init option 2
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// shared init to set contraints
    private func commonInit(){
        //        let bundle = Bundle(for: UIInteractionView.self)
//        Bundle.main.loadNibNamed("UIDynamicView", owner: self, options: nil);
        
        let bundle = Bundle(for: UIDynamicView.self)
        bundle.loadNibNamed("UIDynamicView", owner: self, options: nil)
        
        setFrame()
    }
    
    /// Will change the background color of the dialog
    public func setBackgroundColor(color: UIColor) {
        scrollViewParentView.backgroundColor = color
    }
    
    /// Will prepare the frame for first init
    private func setFrame() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// Will initiate the process of adding a view to the views container
    private func beginViewAddProcedure(_ viewToAdd: UIView, _ horizontalAlignments: [UIViewAlignment]) {
        viewsContainer.addSubview(viewToAdd)
        viewToAdd.refreshLayout()
        let horizontalLocationSet = setViewsContainerSize(viewToAdd, horizontalAlignments)
        if !horizontalLocationSet {
            setHorizontalLocation(viewToAdd, horizontalAlignments)
        }
        setVerticalLocation(viewToAdd)
    }
    
    
    /// Will adjust the horizontal location of the added view
    private func setHorizontalLocation(_ view: UIView, _ alignments: [UIViewAlignment]) {
        alignments.forEach { it in
            switch it {
            case .center:
                view.centralizeHorizontalInParent()
            case .left:
                view.pinToLeadingOfParent(constant: padding)
            case .right:
                view.pinToTrailingOfParent(constant: padding)
            }
        }
    }
    
    private func setEqualWidthToParent(_ view: UIView) {
        // will remove any existing width constraint added
        view.constraints.forEach { it in
            if it.identifier == CONSTRAINT_WIDTH_ID {
                it.isActive = false
            }
        }
        
        view.pinToParentHorizontally(constant: padding)
        view.refreshLayout()
    }
    
    /// Will set the container size according to the margin, padding width and height of the inner views
    private func setViewsContainerSize(_ view: UIView, _ horizontalAlignments: [UIViewAlignment]) -> Bool {
        var horizontalLocationSet = false
        
        // if, for some reason, the width of the view will be equal to the maximum width of the parent,
        // we will set the width of the view to be equal to the parent max and set the height accordingly
        if view.frame.width + (padding * 2) >= maxViewsContainerWidth {
            if currViewsContainerWidth != maxViewsContainerWidth {
                viewsContainerWidthConstr.isActive = false
                currViewsContainerWidth = maxViewsContainerWidth
                viewsContainerWidthConstr = viewsContainer.widthAnchor.constraint(equalToConstant: currViewsContainerWidth)
                viewsContainerWidthConstr.isActive = true
            }
            horizontalLocationSet = true
            setEqualWidthToParent(view)
        } else if view.frame.width > currViewsContainerWidth {
            viewsContainerWidthConstr.isActive = false
            currViewsContainerWidth = view.frame.width
            viewsContainerWidthConstr = viewsContainer.widthAnchor.constraint(equalToConstant: currViewsContainerWidth + padding * 2)
            viewsContainerWidthConstr.isActive = true
        }
        viewsContainerHeightConstr.isActive = false
        
        var heightToAppend = view.frame.height
        if let tv = view as? UITextView {
            heightToAppend = setAndGetUITextViewHeight(tv)
        }
        
        currViewsContainerHeight += heightToAppend + spaceBetweenViews
        viewsContainerHeightConstr = viewsContainer.heightAnchor.constraint(equalToConstant: currViewsContainerHeight)
        viewsContainerHeightConstr.isActive = true
        return horizontalLocationSet
    }
    
    /// Will return and set the uitextview height by it's width and content
    private func setAndGetUITextViewHeight(_ tv: UITextView) -> CGFloat {
        let sizeToFitIn = CGSize(width: tv.frame.width, height: CGFloat(MAXFLOAT))
        let newSize = tv.sizeThatFits(sizeToFitIn)
        tv.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        return newSize.height
    }
    
    /// Will append a UILabel
    ///
    /// - Parameter initialProps: The UILabel initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialLabelProps, invalidate: Bool = true) -> UILabel {
        let label = UILabel()
        label.tag = initialProps.tag
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = initialProps.lineHeightMultiply
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        label.attributedText = NSAttributedString(string: initialProps.text, attributes: attributes)
        
        if let color = initialProps.textColor {
            label.textColor = color
        }
        label.numberOfLines = initialProps.numberOfLines
        label.font = initialProps.font
        label.sizeToFit()
        if invalidate {
            beginViewAddProcedure(label, [initialProps.textAlignment])
        }
        return label
    }
    
    /// Will append a LinkableUITextView. a LinkableUITextView is a UITextView with the ability to make a text clickable and navigate to a certain apps (intent) using URLSchemes.
    /// NOTICE: in order to make the text clickable, save the view from the return and call view.setClickablePart() to set the clickable part on it. When doing so, give original name for the variable and not just "view": let originalName = InitialLinkableUITextViewProps()" cause let view will make the app crash if you create the view from the view controller.
    ///
    /// - Parameter initialProps: The initial props of the LinkableUITextView
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUILinkableTextViewProps, invalidate: Bool = true) -> UILinkableTextView {
        let tv = UILinkableTextView()
        tv.tag = initialProps.tag
        tv.translatesAutoresizingMaskIntoConstraints = false
        if let color = initialProps.textColor {
            tv.textColor = color
        }
        tv.setText(text: initialProps.fullText, lineHeightMultiple: initialProps.lineHeightMultiply)
        tv.isEditable = initialProps.isEditable
        tv.font = initialProps.font
        tv.sizeToFit()
        if invalidate {
            beginViewAddProcedure(tv, [initialProps.textAlignment])
        }
        return tv
    }
    
    
    /// Will append a UIButton
    ///
    /// - Parameter initialProps: The UIButton initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialButtonProps,
                         invalidate: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = initialProps.tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAllStatesTitle(initialProps.labelText)
        button.addTarget(initialProps.tapTarget, action: initialProps.tapSelector, for: .touchUpInside)
        button.titleLabel!.font = initialProps.font
        if let color = initialProps.textColor {
            button.titleLabel?.textColor = color
        }
        button.titleLabel!.sizeToFit()
        button.sizeToFit()
        if invalidate {
            beginViewAddProcedure(button, [initialProps.alignment])
        }
        return button
    }
    
        
    /// Will append a UITextField
    ///
    /// - Parameter initialProps: The UITextField initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUITextFieldProps, invalidate: Bool = true) -> UITextField {
        let tf = UITextField()
        tf.tag = initialProps.tag
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = initialProps.font
        tf.text = String(repeating: "-", count: initialProps.approximateCharCount)
        tf.placeholder = initialProps.placeHolder
        tf.contentVerticalAlignment = .center
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = initialProps.autoCorrect
        tf.addDoneButton()
        tf.keyboardType = initialProps.keyboardType
        tf.sizeToFit()
        tf.backgroundColor = initialProps.backgroundColor
        tf.textColor = initialProps.textColor
        tf.setWidth(width: tf.frame.width)
        tf.setHeight(height: tf.frame.height)
        //        tf.textAlignment = textAlignment
        if invalidate {
            beginViewAddProcedure(tf, [initialProps.alignment])
        }
        tf.text = ""
        return tf
    }
    
    /// Will append a UIImageView
    ///
    /// - Parameter initialProps: The UIImageView initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUIImageViewProps, invalidate: Bool = true) -> UIImageView {
        
        // set image
        let image = UIImage(named: initialProps.imageName)!
        let imgWidth = CGFloat(maxInnerSize * initialProps.widthPercentFromParent)
        let widthFactor = imgWidth/image.size.width
        let imgHeight = image.size.height * widthFactor
        
        // add the image
        let iv = UIImageView()
        iv.tag = initialProps.tag
        iv.translatesAutoresizingMaskIntoConstraints = false
        let ivWidthConstr = iv.widthAnchor.constraint(equalToConstant: imgWidth)
        ivWidthConstr.identifier = CONSTRAINT_WIDTH_ID
        ivWidthConstr.isActive = true
        iv.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        iv.image = image
        if invalidate {
            beginViewAddProcedure(iv, [initialProps.alignment])
        }
        
        return iv
    }
    
    
    /// Will append a YoutubeVideoView
    ///
    /// - Parameter initialProps: The YoutubeVideo initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialYoutubeVideoProps,
                                invalidate: Bool = true) -> YTPlayerView {
        // set youtube video
        let ytPlayerView = YTPlayerView()
        ytPlayerView.translatesAutoresizingMaskIntoConstraints = false
        ytPlayerView.tag = initialProps.tag
        
        let ytWidth = CGFloat(maxInnerSize * initialProps.widthPercentFromParent)
        let ytHeight = ytWidth * initialProps.heightPercentFromWidth
        
        let ytWidthConstr = ytPlayerView.widthAnchor.constraint(equalToConstant: ytWidth)
        ytWidthConstr.identifier = CONSTRAINT_WIDTH_ID
        ytWidthConstr.isActive = true
        ytPlayerView.heightAnchor.constraint(equalToConstant: ytHeight).isActive = true
        loadYoutubeVideo(playerView: ytPlayerView, videoId: initialProps.videoId)
        if invalidate {
            beginViewAddProcedure(ytPlayerView, [initialProps.alignment])
        }
        return ytPlayerView
    }
    
    /// Will append a UIStackView
    ///
    /// - Parameter initialProps: The StackView initial props
    @discardableResult
    public func addView(initialProps: InitialStackViewProps, invalidate: Bool = true) -> UIStackView {
        var viewList = [UIView]()
        initialProps.subviewsInitialPropsList.forEach { it in
            switch it.getType() {
            case .label:
                viewList.append(addView(initialProps: it as! InitialLabelProps, invalidate: false))
            case .linkableTextView:
                viewList.append(addView(initialProps: it as! InitialUILinkableTextViewProps, invalidate: false))
            case .textField:
                viewList.append(addView(initialProps: it as! InitialUITextFieldProps, invalidate: false))
            case .imageView:
                viewList.append(addView(initialProps: it as! InitialUIImageViewProps, invalidate: false))
            case .youtubeVideo:
                viewList.append(addView(initialProps: it as! InitialYoutubeVideoProps, invalidate: false))
            case .button:
                viewList.append(addView(initialProps: it as! InitialButtonProps, invalidate: false))
            case .stackView:
                viewList.append(addView(initialProps: it as! InitialStackViewProps, invalidate: false))
            }
        }
        
        // sv
        let sv = UIStackView()
        sv.tag = initialProps.tag
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = initialProps.axis
        sv.distribution = initialProps.distribution
        
        viewList.forEach { it in
            sv.addArrangedSubview(it)
        }
        sv.spacing = initialProps.spacing
        if invalidate {
            beginViewAddProcedure(sv, [.left, .right])
        }
        return sv
    }
    
    /// Will return any added view
    ///
    /// - Parameter tag: The view's tag you set
    public func getView<T: UIView>(tag: Int) -> T {
        return viewsContainer.viewWithTag(tag) as! T
    }
    
    /// Will attach the view to it's parent view. Call this function when you're done adding views and you want to pop the view
    ///
    /// - Parameter parentView: The parent view to attach to
    public func attachView(parentView: UIView,
                           toParentTopSafeArea: Bool = true,
                           toParentBottomSafeArea: Bool = true,
                           preventInteractionWithOtherViews: Bool = true) {
        // refresh the container
        viewsContainer.refreshLayout()
        
        // add the view and attach it to the top and centrelaize x
        parentView.addSubview(self)
        
        self.toParentTopSafeArea = toParentTopSafeArea
        self.toParentBottomSafeArea = toParentBottomSafeArea
        pinToParentTop(toMargins: toParentTopSafeArea, constant: topMargin)
        centralizeHorizontalInParent()
        
        // disable touches with other views, if required
        if preventInteractionWithOtherViews {
            toggleInteractionWithSiblingViews(interactable: false)
        }
        
        
        // attach bottom to bottom if height is too great
        updateHeight()
        subscribeKeyboardObservers()
    }
    
    /// You should call this function if there is a change in the height of the parent view (if you're adding ads, for example) after the view has already been inflated
    public func updateHeight() {
        if let parentView = superview {
            let distanceFromTop = calcDistanceFromTopSafeArea()
            if let bottomConstr = viewsContainerBottomConstr {
                bottomConstr.isActive = false
            }
            if viewsContainer.frame.height + topMargin + distanceFromTop > parentView.frame.height {
                viewsContainerBottomConstr = pinToParentBottom(toMargins: toParentBottomSafeArea, constant: bottomMargin)
                
            } else {
                viewsContainerBottomConstr = setHeight(height: viewsContainer.frame.height + topMargin)
            }
        }
    }
    
    private func calcDistanceFromTopSafeArea() ->  CGFloat {
        if !toParentTopSafeArea {
            return 0
        }
        if let parentView = superview {
//            if #available(iOS 11.0, *) {
//                return parentView.safeAreaInsets.top
//            } else {
                if let parentTopGuide = parentView.parentViewController?.topLayoutGuide.length {
                    return parentTopGuide
                } else {
                    return 44
                }
            }
        
        return 0
    }
    
    
    private func loadYoutubeVideo(playerView: YTPlayerView, videoId: String) {
        playerView.load(withVideoId: videoId, playerVars: ["playsinline" : 1])
    }
    
    /// Will set the latest added view
    private func setVerticalLocation(_ view: UIView) {
        if let _latestViewAdded = latestViewAdded {
            view.topAnchor.constraint(equalTo: _latestViewAdded.bottomAnchor, constant: spaceBetweenViews).isActive = true
        } else {
            view.pinToParentTop(constant: padding)
        }
        
        latestViewAdded = view
    }
    
    // MARK: - keyboard observers
    func subscribeKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Will detach any observers and remove from super view
    public override func removeFromSuperview() {
        unsubscribeKeyboardObservers()
        if !siblingViewsInteractable {
            toggleInteractionWithSiblingViews(interactable: true)
        }
        super.removeFromSuperview()
    }
    
    private func toggleInteractionWithSiblingViews(interactable: Bool) {
        siblingViewsInteractable = interactable
        superview!.subviews.forEach { it in
            if it != self {
                it.isUserInteractionEnabled = interactable
            }
        }
    }
    
    @objc func willShowKeyboard(notification: NSNotification) {
        containerViewTopConstrConst = containerViewTopConstr.constant
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardHeight = keyboardFrame.size.height
        if let currentView = firstResponder {
            let viewYLocation = currentView.frame.origin.y
            let scrolledY = scrollView.contentOffset.y
            let viewToTopConst = viewYLocation - scrolledY
            containerViewTopConstr.constant = -viewToTopConst + 16 // we will save a little bit of margin from the top
        }
    }
    
    /// Will close the keyboard if displayed
    public func closeKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
        willHideKeyboard()
    }
    
    @objc func willHideKeyboard()
    {
        containerViewTopConstr.constant = containerViewTopConstrConst
    }
    
    
}


extension Array where Element == UIViewAlignment {
    
    /// Will append a bunch of items if they aren't exist in the array
    public mutating func appendIfNoExists(elements: [UIViewAlignment]) {
        elements.forEach { it in
            if !contains(it) {
                append(it)
            }
        }
        
    }
}


