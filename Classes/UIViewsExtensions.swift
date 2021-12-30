//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation


// MARK: - UIViewController
extension UIViewController {
    
    /// Will return the view controller as defined in the storyboard
    public func getVC<T: UIViewController>(withIdentifier: String) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! T
    }
    
    
    /// Will set a custom back button. Make sure to add the image cause it's an image based back button
    public func setCustomBackBtnAction(imageName: String, action: Selector) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: imageName),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    /// Will hide the back button.
    /// NOTICE: You should fire the function FROM THE VIEW CONTROLLER WHO CALLS THE NEW VIEW CONTROLLER!
    public func hideBackBtn() {
        self.navigationItem.title = ""
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    
}

// MARK: - UIColor
extension UIColor {
    
    /// Will init a ui color using hex string: "#ffffff" for white, for example
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(CFloat(r) / 255), green: CGFloat(CFloat(g) / 255), blue: CGFloat(Float(b) / 255), alpha: CGFloat(Float(a) / 255))
    }
}

// MARK: - UIView
extension UIView {

    
    /// Will init a flip animation on a view on place (like a coin animation flip around it's (0,0 value)
    public func flip(animate: AnimationOptions = .transitionFlipFromRight,
                     didHalfFlip: (() -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        let transitionOptions: UIView.AnimationOptions = [animate, .showHideTransitionViews]

        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            self.hide(true)
            didHalfFlip?()
            UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
                self.hide(false)
                completion?()
            })
        })
    }
    
    
    
    /// Will scale the view by
    public func scale(by: CGFloat, withDuration: TimeInterval = 0.3) {
        UIView.animate(withDuration: withDuration, animations: {
            self.transform = CGAffineTransform(scaleX: by, y: by)
        })
    }
    
    /// Will refresh the layout of all of the subviews
    public func refreshLayoutAllSubviews() {
        subviews.forEach { it in
            if let label = it as? UILabel {
                label.sizeToFit()
            }
            it.refreshLayoutAllSubviews()
        }
        refreshLayout()
    }
    
    /// Wil return the height constraint, if exists
    public func getHeightConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if let firstItem = constraint.firstItem,
               let firstObj = firstItem as? NSObject,
               firstObj == self,
               constraint.firstAttribute == .height {
                return constraint
            } else if let secondItem = constraint.secondItem,
                      let secondObj = secondItem as? NSObject,
                      secondObj == self,
                      constraint.secondAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    /// Wil return the width constraint, if exists
    public func getWidthConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if let firstItem = constraint.firstItem,
               let firstObj = firstItem as? NSObject,
               firstObj == self,
               constraint.firstAttribute == .width {
                return constraint
            } else if let secondItem = constraint.secondItem,
                      let secondObj = secondItem as? NSObject,
                      secondObj == self,
                      constraint.secondAttribute == .width {
                return constraint
            }
        }
        return nil
    }
    
    /// Wil return the top constraint, if exists
    public func getTopConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if let firstItem = constraint.firstItem,
               let firstObj = firstItem as? NSObject,
               firstObj == self,
               constraint.firstAttribute == .top {
                return constraint
            } else if let secondItem = constraint.secondItem,
                      let secondObj = secondItem as? NSObject,
                      secondObj == self,
                      constraint.secondAttribute == .height {
                return constraint
            }
        }
        return nil
    }
    
    /// Will do a jump madafaka jump animation
    public func doJumpAnimation(completion: (() -> Void)? = nil) {
        
        transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       },
                       completion: { Void in
                        completion?()
                       }
        )
    }
    
    /// Wil update a view height constraint. If the height constraint doesn't exists, will create it. For disabling animation, put 0.0 in the interval
    public func updateHeightConstraint(newHeight: CGFloat,
                                       animateInterval: TimeInterval = 0.0,
                                       _ completion: @escaping () -> Void) {
        guard let superview = superview else {
            completion()
            return
        }
        var heightConstr = getHeightConstraint()
        if heightConstr == nil {
            heightConstr = setHeight(height: 0)
            layoutIfNeeded()
        }
        if heightConstr!.constant == newHeight {
            completion()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            heightConstr!.constant = newHeight
            if animateInterval != 0.0 {
                UIView.animate(withDuration: animateInterval, animations: {
                    superview.layoutIfNeeded()
                }) { done in
                    completion()
                }
            } else {
                completion()
            }
            
        }
    }
    
    /// Wil update a view width constraint. If the width constraint doesn't exists, will create it. For disabling animation, put 0.0 in the interval
        public func updateWidthConstraint(newWidth: CGFloat,
                                       animateInterval: TimeInterval = 0.0,
                                       _ completion: @escaping () -> Void) {
        guard let superview = superview else {
            completion()
            return
        }
        var widthConstr = getWidthConstraint()
        if widthConstr == nil {
            widthConstr = setWidth(width: 0)
            layoutIfNeeded()
        }
        if widthConstr!.constant == newWidth {
            completion()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            widthConstr!.constant = newWidth
            if animateInterval != 0.0 {
                UIView.animate(withDuration: animateInterval, animations: {
                    superview.layoutIfNeeded()
                }) { done in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    
    /// Will return an identical constraint with the parent view (bottom to bottom, for example)
    public func getConstraintWithParent(attributes: [NSLayoutConstraint.Attribute]) -> NSLayoutConstraint? {
        guard let superview = superview else {return nil}
        return superview.getConstraintWithView(secondView: self, attributes: attributes)
    }
    
    /// Will return the first identical constraint with a child (bottom to bottom, for example). Notice: this won't be accurate if the view has more than 1 children with the same specs (for example, if two children are top to top of parent)
    public func getConstraintWithFirstChild(attributes: [NSLayoutConstraint.Attribute]) -> NSLayoutConstraint? {
        for it in constraints {
            
            if let firstView = getViewFromConstraintItem(item: it.firstItem),
               let secondView = getViewFromConstraintItem(item: it.secondItem) {
            
                if firstView == self && attributes.contains(it.firstAttribute) {
                    if secondView != superview! && attributes.contains(it.secondAttribute) {
                        return it
                    }
                } else if secondView == self && attributes.contains(it.secondAttribute) {
                    if firstView != superview! && attributes.contains(it.firstAttribute) {
                        return it
                    }
                }
            }
        }
        return nil
    }
    
    
    /// Will return an identical constraint with another view (bottom to bottom, for example)
    public func getConstraintWithView(secondView: UIView,
                                       attributes: [NSLayoutConstraint.Attribute]) -> NSLayoutConstraint? {
        for it in constraints {
            if checkIfViewAttributesAlign(constraint: it,
                            desiredFirstView: [self],
                            desiredFirstViewAttrib: attributes,
                            desiredSecondView: [secondView],
                            desiredSecondViewAttrib: attributes) {
                return it
            }
        }
        return nil
    }
    
    /// Will check if two views attributes align with each other
    public func checkIfViewAttributesAlign(constraint: NSLayoutConstraint,
                             desiredFirstView: [UIView],
                             desiredFirstViewAttrib: [NSLayoutConstraint.Attribute],
                             desiredSecondView: [UIView],
                             desiredSecondViewAttrib: [NSLayoutConstraint.Attribute]) -> Bool {
        guard let firstView = getViewFromConstraintItem(item: constraint.firstItem),
              let secondView = getViewFromConstraintItem(item: constraint.secondItem) else {return false}
        
        if desiredFirstView.contains(firstView) && desiredFirstViewAttrib.contains(constraint.firstAttribute) {
            if desiredSecondView.contains(secondView) && desiredSecondViewAttrib.contains(constraint.secondAttribute) {
                return true
            }
        }
        if desiredFirstView.contains(secondView) && desiredFirstViewAttrib.contains(constraint.secondAttribute) {
            if desiredSecondView.contains(firstView) && desiredSecondViewAttrib.contains(constraint.firstAttribute) {
                return true
            }
        }
        return false
    }
    
    /// Will return a view from a constraint layout
    public func getViewFromConstraintItem(item: AnyObject?) -> UIView? {
        guard let item = item else {return nil}
        if let layoutGuide = item as? UILayoutGuide {
            if let owningView = layoutGuide.owningView {
                return owningView
            }
        } else if let view = item as? UIView {
            return view
        }
        return nil
    }
    
    
    
    /// Will perform a slide view animation to the middle of the screen. If no top constraint to parent, will animate from bottom
    /// Notice: you should probably set the width and the x aligment of the view before calling this function
    public func slideAnimateToCentralizeY(contentHeight: CGFloat,
                                          animationDuration: TimeInterval = 0.5,
                                          yAdjustments: CGFloat = 0,
                                          completion: (() -> Void)? = nil) {
        
        let windowHeight = UIScreen.main.bounds.size.height
        let yLocation = (windowHeight / 2) - (contentHeight / 2) + yAdjustments
        slideAnimateToY(yLocation: yLocation, animationDuration: animationDuration, completion: completion)
    }
    
    /// Will perform a slide view animation to bottom. If no top constraint exists to parent, will do nothing.
    /// Notice: you should probably set the width and the x aligment of the view before calling this function
    public func slideAnimateToBottom(animationDuration: TimeInterval = 0.5,
                                     completion: (() -> Void)? = nil) {
        slideAnimateToY(yLocation: UIScreen.main.bounds.size.height,
                        animationDuration: animationDuration,
                        completion: completion)
    }
    
    /// Willl perform a slide animation to a given y point on screen.
    /// Notice: the animation made using moving the top constraint with the parent top. If you're expecting any weird behaviour notice that
    /// Also, you should probably set the width and the x aligment of the view before calling this function
    public func slideAnimateToY(yLocation: CGFloat,
                                animationDuration: TimeInterval = 0.5,
                                completion: (() -> Void)? = nil) {
        
        var topConstraint: NSLayoutConstraint
        let windowHeight = UIScreen.main.bounds.size.height
        if let viewTopConstr = getConstraintWithParent(attributes: [.top, .topMargin]) {
            topConstraint = viewTopConstr
        } else {
            topConstraint = pinToParentTop(toMargins: true, constant: windowHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            topConstraint.constant = yLocation
            UIView.animate(withDuration: animationDuration, animations: {
                self.superview!.layoutIfNeeded()
            }) { _ in
                completion?()
            }
        }
    }
    
    /// Will return the parent view controller, if available
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    /// Will add a blurry effect to a view.
    /// NOTICE: the blurAnimatorMember should be saved in your class, as member, and sent here
    public func setBlurEffect(blurAnimatorMember: inout UIViewPropertyAnimator?,
                              viewTag: Int = 9090,
                              blurIntensity: CGFloat = 0.15,
                              colorIfBlurNoAvailable: UIColor = .black) -> Bool {
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            backgroundColor = .clear
            let blurEffectView = UIVisualEffectView()
            blurEffectView.backgroundColor = .clear
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
            
            blurAnimatorMember = UIViewPropertyAnimator(duration: 1, curve: .linear) { [blurEffectView] in
                blurEffectView.effect = UIBlurEffect(style: .light)
            }
            
            blurAnimatorMember!.fractionComplete = blurIntensity
            blurEffectView.tag = viewTag
            blurEffectView.alpha = 0
            insertSubview(blurEffectView, at: 0)
            blurEffectView.fadeIn {
                
            }
            return true
        } else {
            backgroundColor = colorIfBlurNoAvailable
            return false
        }
    }
    
    /// Will add a top border to a view
    public func addTopBorder(percentsFromWidth: CGFloat = 1.0, color: UIColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 0.66), height: CGFloat = 1.0 ) {
        let border = CALayer()
        border.frame = CGRect(x: frame.width * ((1.0 - percentsFromWidth)/2),
                              y: 0,
                              width: frame.width * percentsFromWidth,
                              height: height)
        border.backgroundColor = color.cgColor
        layer.addSublayer(border)
    }
    
    /// Will hide/show a view
    public func hide(_ hide: Bool){
        DispatchQueue.main.async {
            self.isHidden = hide
        }
    }
    
    /// Will run a "blink" animation to a view
    public func blink(duration: TimeInterval = 0.5,
                      delay: TimeInterval = 0.0,
                      alpha: CGFloat = 0.0,
                      repeatCount: Float = 2,
                      allowUserInteractionDuringBlink: Bool = true) {
        
        let initialAlpha = self.alpha
        var options: UIView.AnimationOptions = [.curveEaseInOut, .repeat, .autoreverse]
        if allowUserInteractionDuringBlink {
            options.insert(.allowUserInteraction)
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            UIView.setAnimationRepeatCount(repeatCount)
            self.alpha = alpha
        }, completion: { completed in
            self.alpha = initialAlpha
        })
    }
    
    /// Will remove the corners of a view
    public func removeRoundCorners() {
        layer.cornerRadius = 0
        if #available(iOS 11.0, *) {
            layer.maskedCorners = CACornerMask()
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// Will do a fade in effect on a view
    public func fadeIn(withDuration: TimeInterval = 0.5, delay: TimeInterval = 0, toAlpha: CGFloat = 1, _ completion: @escaping () -> Void){
        fade(fromAlpha: alpha,
             toAlpha: 1.0,
             animationOptions: UIView.AnimationOptions.curveEaseIn,
             duration: withDuration,
             delay: delay,
             completion)
    }
    
    /// Will do a fade out effect on a view
    public func fadeOut(withDuration: TimeInterval = 0.5, delay: TimeInterval = 0, toAlpha: CGFloat = 1, _ completion: @escaping () -> Void){
        fade(fromAlpha: alpha,
             toAlpha: 0,
             animationOptions: UIView.AnimationOptions.curveEaseOut,
             duration: withDuration,
             delay: delay,
             completion)
    }
    
    
    /// Will do a custom fade effect on a view
    public func fade(fromAlpha: CGFloat,
                     toAlpha: CGFloat,
                     animationOptions: UIView.AnimationOptions,
                     duration: TimeInterval = 0.5,
                     delay: TimeInterval = 0,
                     _ completion: @escaping () -> Void) {
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
            self.alpha = toAlpha
        }, completion: { _ in
            completion()
        })
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    /// Will run a rotate animation on a view
    public func rotate(duration: Double = 1) {
        
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    /// Will run a rotate animation on a view
    public func rotate(duration: TimeInterval = 0.5, by: CGFloat = .pi) {
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = self.transform.rotated(by: by)
        })
    }
    
    /// Will stop a rotating
    /// view animation
    public func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
    /// Will return the parent carrying a tag
    public func findParentBy(tag: Int) -> UIView? {
        if let parent = superview {
            if parent.tag == tag {
                return parent
            } else {
                return parent.findParentBy(tag: tag)
            }
        }
        return nil
    }
    
    
    /// Will recursively look for the view with the accessibility Identifier specified
    public func viewWith(_ accessibilityIdentifier: String) -> UIView? {
        if(self.accessibilityIdentifier != nil &&
           self.accessibilityIdentifier == accessibilityIdentifier) {
            return self
        } else if(self.subviews.count > 0) {
            for i in 0..<self.subviews.count {
                let found = self.subviews[i].viewWith(accessibilityIdentifier)
                if(found != nil) {
                    return found
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    /// Will show a view and set it as clickable or hide it and set it unclickable
    public func toggleShowAndClickable(show: Bool) {
        isUserInteractionEnabled = show
        hide(!show)
    }
    
    /// Will add a shadow to a view
    public func dropShadow(scale: Bool = true, shadowRadius: CGFloat = 2.5, opacity: Float = 1) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /// Will adjust view leading and trailing according to parent
    @discardableResult
    public func pinToParentHorizontally(constant: CGFloat = 0) -> [NSLayoutConstraint]{
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToLeadingOfParent(constant: constant))
        constraints.append(pinToTrailingOfParent(constant: constant))
        return constraints
    }
    
    /// Will put the view at the start of the parent
    @discardableResult
    public func pinToLeadingOfParent(toMargins: Bool = false, constant: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        if toMargins {
            constraint = leadingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.leadingAnchor, constant: constant)
        } else {
            constraint = leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    /// Will put the view at the end of the parent
    @discardableResult
    public func pinToTrailingOfParent(toMargins: Bool = false, constant: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if toMargins {
            constraint = trailingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.trailingAnchor, constant: constant)
        } else {
            constraint = trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    /// Will put the view at the x center of the parent
    @discardableResult
    public func centralizeHorizontalInParent(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Will put the view at the y center of the parent
    @discardableResult
    public func centralizeVerticalInParent(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    
    /// Will set the width constraint of a view
    @discardableResult
    public func setWidth(width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    /// Will set the height constraint of a view
    @discardableResult
    public func setHeight(height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    
    /// Will attach the view to the top of it's parent
    @discardableResult
    public func pinToParentTop(toMargins: Bool = false, constant: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if toMargins {
            constraint = topAnchor.constraint(equalTo: superview!.layoutMarginsGuide.topAnchor, constant: constant)
        } else {
            constraint = topAnchor.constraint(equalTo: superview!.topAnchor, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    /// Will attach the view to the bottom of it's parent
    @discardableResult
    public func pinToParentBottom(toMargins: Bool = false, constant: CGFloat = 0) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        if toMargins {
            constraint = bottomAnchor.constraint(equalTo: superview!.layoutMarginsGuide.bottomAnchor, constant: constant)
        } else {
            constraint = bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    /// Will return the currently focused view
    public var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
    
    
    /// Will force fresh the layout of the view
    public func refreshLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UIButton
extension UIButton {
    /// Will set a title for all of the button's states (normal, selected and disabled)
    public func setAllStatesTitle(_ newTitle: String){
        self.setTitle(newTitle, for: .normal)
        self.setTitle(newTitle, for: .selected)
        self.setTitle(newTitle, for: .disabled)
    }
}

// MARK: - UILabel
extension UILabel {
    
    /// Will set the attributed text to a label
    public func setAttributedText(_ newText: String) {
        attributedText = NSAttributedString(string: newText, attributes: attributedText!.attributes(at: 0, effectiveRange: nil))
    }
    
    /// Will set a regual and a bold text in the same label string
    public func setRegualAndBoldText(regualText: String,
                                     boldiText: String) {
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font.pointSize)]
        let regularString = NSMutableAttributedString(string: regualText)
        let boldiString = NSMutableAttributedString(string: boldiText, attributes:attrs)
        regularString.append(boldiString)
        attributedText = regularString
    }
    
    /// will set the text in the label if exists else hide the label
    public func setAttribTextOrHide(_ str: String?) {
        if(str == nil || str == ""){
            hide(true)
        } else {
            hide(false)
            setAttributedText(str!)
        }
    }
    
    /// will set the text in the label if exists else hide the label
    public func setTextOrHide(str: String?) {
        if let str = str {
            isHidden = false
            text = str
        } else {
            isHidden = true
        }
    }
}

// MARK: - UITextField
extension UITextField {
    
    /// Will add a done button to a text view. When clicked, it will resign the first responder. Notice: If you want to add a done button to multiple fields, don't use this function
    public func addDoneButton(title: String = "Done", style: UIBarStyle = .default) {
        
        let applyToolbar = UIToolbar()
        applyToolbar.barStyle = style
        
        applyToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title, style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        
        applyToolbar.sizeToFit()
        inputAccessoryView = applyToolbar
    }
    
    /// Will move the caret to the end of the line
    public func moveCaretToLineEnd() {
        self.selectedTextRange = self.textRange(from: self.endOfDocument, to: self.endOfDocument)
    }
}

// MARK: - UIStackView
extension UIStackView {
    
    /// Will remove all of the subviews of the stack view
    public func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

// MARK: - UIScrollView
extension UIScrollView {
    
    /// Will scroll to the desired page in the scroll view
    public func scrollToPage(number: Int) {
        var scrollFrame = frame
        scrollFrame.origin.x = scrollFrame.size.width * CGFloat(number)
        scrollFrame.origin.y = 0
        scrollRectToVisible(scrollFrame, animated: true)
    }
    
    public var isAtTop: Bool {
        return contentOffset.y <= topVerticalOffset
    }

    public var isAtBottom: Bool {
        return contentOffset.y >= bottomVerticalOffset
    }

    public var topVerticalOffset: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    public var bottomVerticalOffset: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

// MARK: - UITextView
extension UITextView :UITextViewDelegate {
    
    /// Will add a done button to a text view. When clicked, it will resign the first responder. Notice: If you want to add a done button to multiple fields, don't use this function
    public func addDoneButton(title: String = "Done", style: UIBarStyle = .default) {
        
        let applyToolbar = UIToolbar()
        applyToolbar.barStyle = style
        
        applyToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title, style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        
        applyToolbar.sizeToFit()
        inputAccessoryView = applyToolbar
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
    /// Will update the uitextview height by it's width and content
    @discardableResult
    func updateAndGetTextViewHeight() -> CGFloat {
        let sizeToFitIn = CGSize(width: frame.width, height: CGFloat(MAXFLOAT))
        let newSize = sizeThatFits(sizeToFitIn)
        heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        return newSize.height
    }
    
}
