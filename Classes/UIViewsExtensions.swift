//
//  LinkableUITextView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 27/09/2020.
//  Copyright © 2020 osFunApps. All rights reserved.
//

import Foundation



// MARK: - UIApplication
extension UIApplication {

    /// Will return the currently top view controller
    public class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    
    /// The  safe way to remove all of the vcs in the stack except last one
    public func removeAllExceptLast() {
        var navigationArray = viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) //To remove all previous UIViewController except the last one
        viewControllers = navigationArray
    }
    
    /// The  safe way to remove all of the vcs in the stack except a kind
    public func removeAllExceptOfKind(t: UIViewController.Type) {
        var navigationArray = viewControllers // To get all UIViewController stack as Array
        guard let vc = navigationArray.first(where: {type(of: $0) == t}) else {
            fatalError("Couldn't find the vc in the stack!")
        }
        navigationArray.removeAll()
        navigationArray.append(vc) //To remove all previous UIViewController except the last one
        viewControllers = navigationArray
    }
    
    
    /// The  safe way to remove vc of kind
    public func removeOfKind(t: UIViewController.Type,
                             removePreceedingVCS: Bool = false) {
        var navigationArray = viewControllers // To get all UIViewController stack as Array
        
        if let vcIdx = navigationArray.firstIndex(where: {type(of: $0) == t}) {
            
            if removePreceedingVCS {
                for i in 0...vcIdx {
                    navigationArray.remove(at: i)
                }
            }
            viewControllers = navigationArray
        }
    }
    
    /// Will set the font and color of the title. NOTICE: gotta run from the old view controller who pushes the new!!
    public func setTitleFontAndColor(font: UIFont, color: UIColor) {
        
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ]
        
        if #available(iOS 13.0, *) {
            let appearance = navigationBar.standardAppearance
            appearance.titleTextAttributes = attrs
            setAllAppearances(appearance: appearance)
        } else {
            navigationBar.titleTextAttributes = attrs
            //            navigationBar.backgroundColor = .white
        }
    }
    
    /// Will set the navigation controller back button image
    public func setBackButtonImage(image: UIImage) {
        if #available(iOS 13.0, *) {
            let appearance = navigationBar.standardAppearance
            appearance.setBackIndicatorImage(image, transitionMaskImage: image)
            setAllAppearances(appearance: appearance)
        } else {
            let proxy = UINavigationBar.appearance()
            proxy.backIndicatorImage = image
            proxy.backIndicatorTransitionMaskImage = image
        }
    }
    
    /// Will set the navigation controller back button color
    public func setBackButtonColor(color: UIColor) {
        navigationBar.tintColor = color
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = color
        //        let proxy = UINavigationBar.appearance()
        //        proxy.tintColor = color
    }
    
    /// Will remove the black line from the navigation controller
    public func removeHairline(navigationBackgroundColor: UIColor = .white) {
        
        if #available(iOS 13.0, *) {
            let appearance = navigationBar.standardAppearance
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = navigationBackgroundColor
            setAllAppearances(appearance: appearance)
        } else {
            self.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.layoutIfNeeded()
        }
    }
    
    /// Will set a background color for the navigation bar
    public func setBackgroundColor(color: UIColor) {
        
        if #available(iOS 13.0, *) {
            let appearance = navigationBar.standardAppearance
            appearance.backgroundColor = color
            setAllAppearances(appearance: appearance)
        } else {
            navigationBar.backgroundColor = color
//
        }
    }
    
    /// Will restore the black line from the navigation controller
    public func restoreHairline() {
        self.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.layoutIfNeeded()
    }
    /// Will set all of the appearances of the navigation controller
    @available(iOS 13.0, *)
    public func setAllAppearances(appearance: UINavigationBarAppearance) {
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    /// Will return the view controller as defined in the storyboard
    public func getVC<T: UIViewController>(storyBoardName: String = "Main", withIdentifier: String) -> T {
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! T
    }
    
    /// Will set an action to the back button
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
    
    public func pinLeadingToLeading(of view: UIView, with constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }
    public func pinLeadingToTrailing(of view: UIView, with constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    public func pinTrailingToTrailing(of view: UIView, with constant: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    public func pinTrailingToLeading(of view: UIView, with constant: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }
    public func pinTopToTop(of view: UIView, with constant: CGFloat = 0) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    public func pinTopToBottom(of view: UIView, with constant: CGFloat = 0) {
        topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    public func pinBottomToTop(of view: UIView, with constant: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    public func pinBottomToBottom(of view: UIView, with constant: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    
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
    
    /// Will start a jiggling animation (like long hold on ios items)
    public func startJigglingWigglingAnimation(rotationAngle: CGFloat = 0.05,
                                               translationY: CGFloat = 0.8,
                                               translationX: CGFloat = 0.8,
                                               duration: CGFloat = 0.25) {
        if layer.animation(forKey: "rorationZ") == nil {
            let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            wiggle.values = [-rotationAngle, rotationAngle]
            wiggle.autoreverses = true
            wiggle.duration = duration
            wiggle.repeatCount = Float.infinity
            layer.add(wiggle, forKey: "rorationZ")
        }
        
        if  layer.animation(forKey: "translationY") == nil {
            let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
            bounce.values = [-translationY, translationY]
            bounce.autoreverses = true
            bounce.duration = duration
            bounce.repeatCount = Float.infinity
            layer.add(bounce, forKey: "translationY")
        }
        
        if layer.animation(forKey: "translationX") == nil {
            let bounce2 = CAKeyframeAnimation(keyPath: "transform.translation.x")
            bounce2.values = [-translationX, translationX]
            bounce2.autoreverses = true
            bounce2.duration = duration
            bounce2.repeatCount = Float.infinity
            layer.add(bounce2, forKey: "translationX")
        }
    }
    
    /// Will stop a running jiggling wiggling animation
    public func stopJigglingWigglingAnimation() {
        layer.removeAnimation(forKey: "rorationZ")
        layer.removeAnimation(forKey: "translationY")
        layer.removeAnimation(forKey: "translationX")
    }
    
    
    /// Will return a constraint with a brother.
    /// NOTICE: The superview holds the connections between brothers so make sure have superview here!
    public func getConstraintWithSibling(constraints: [NSLayoutConstraint.Attribute]) -> NSLayoutConstraint? {
        guard let superview = superview else {return nil}
        for constraint in superview.constraints {
            if let firstObj = constraint.firstItem as? NSObject,
               firstObj == self,
               constraints.contains(constraint.firstAttribute) {
                return constraint
            }
            if let secondItem = constraint.secondItem as? NSObject,
               secondItem == self,
               constraints.contains(constraint.secondAttribute) {
                return constraint
            }
        }
        return nil
    }
    
    /// Will add a dashed border to a view
    public func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [3,3] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: frame.width/2).cgPath
        
        self.layer.addSublayer(shapeLayer)
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
    
    /// NOTICE: Call this top update the height of a view from iOS smaller than 13.0. Otherwise, it will produce a bug
    /// Wil update a view height constraint. If the height constraint doesn't exists, will create it. For disabling animation, put 0.0 in the interval
    public func updateHeightConstraint(newHeight: CGFloat,
                                       animateInterval: TimeInterval = 0.0,
                                       _ completion: (() -> Void)? = nil) {
        
        var heightConstr = getHeightConstraint()
        if heightConstr == nil {
            heightConstr = setHeight(height: 0)
            layoutIfNeeded()
        }
        if heightConstr!.constant == newHeight {
            completion?()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            heightConstr!.constant = newHeight
            if animateInterval != 0.0 {
                guard let superview = self.superview else {
                    completion?()
                    return
                }
                UIView.animate(withDuration: animateInterval, animations: {
                    superview.layoutIfNeeded()
                }) { done in
                    completion?()
                }
            } else {
                completion?()
            }
            
        }
    }
    
    /// Wil update a view width constraint. If the width constraint doesn't exists, will create it. For disabling animation, put 0.0 in the interval
    public func updateWidthConstraint(newWidth: CGFloat,
                                      animateInterval: TimeInterval = 0.0,
                                      _ completion: (() -> Void)? = nil) {
        var widthConstr = getWidthConstraint()
        if widthConstr == nil {
            widthConstr = setWidth(width: 0)
            layoutIfNeeded()
        }
        if widthConstr!.constant == newWidth {
            completion?()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            widthConstr!.constant = newWidth
            if animateInterval != 0.0 {
                guard let superview = self.superview else {
                    completion?()
                    return
                }
                UIView.animate(withDuration: animateInterval, animations: {
                    superview.layoutIfNeeded()
                }) { done in
                    completion?()
                }
            } else {
                completion?()
            }
        }
    }
    
    /// Will drop generic table view shadow
    public func dropTableViewShadow(masksToBounds: Bool = true,
                                    clipsToBounds: Bool = true) {
        dropShadow(masksToBounds: masksToBounds,
                   clipsToBounds: clipsToBounds,
                   color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor,
                   offset: .zero,
                   opacity: 0.50,
                   radius: 10)
    }
    
    /// Will drop a generic shadow. Usually for containers
    public func dropGenericShadow(masksToBounds: Bool = true,
                                  clipsToBounds: Bool = true) {
        dropShadow(masksToBounds: masksToBounds,
                   clipsToBounds: clipsToBounds,
                   color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5835141552).cgColor,
                   offset: CGSize(width: 3, height: 3),
                   opacity: 0.45,
                   radius: 6.0)
    }
    
    /// Will drop the a generic button shadow
    public func dropBtnShadow(masksToBounds: Bool = true,
                              clipsToBounds: Bool = false) {
        dropShadow(masksToBounds: masksToBounds,
                   clipsToBounds: clipsToBounds,
                   color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor,
                   offset: CGSize(width: 0, height: 3),
                   opacity: 1.0,
                   radius: 10.0)
    }
    
    /// Will add the new shadow design to to a view
    public func dropShadow(masksToBounds: Bool = true,
                           clipsToBounds: Bool = true,
                           color: CGColor,
                           offset: CGSize,
                           opacity: Float,
                           radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = masksToBounds
        self.clipsToBounds = clipsToBounds
        
        // cache
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    // Will search for a view tag recursively
    public func viewWithTag(tag: Int, recursive: Bool = false) -> UIView? {
        if recursive {
            for currView in subviews {
                let foundView = currView.viewWithTag(tag: tag, recursive: true)
                if foundView != nil {
                    return foundView
                }
            }
        }
        return viewWithTag(tag)
    }
    
    public func bottomConstraintWithParent(inclMargin: Bool = true) -> NSLayoutConstraint? {
        var attrib = [NSLayoutConstraint.Attribute](arrayLiteral: .bottom)
        if inclMargin {
            attrib.append(.bottomMargin)
        }
        return getConstraintWithParent(attributes: attrib)
    }
    
    public func topConstraintWithParent(inclMargin: Bool = true) -> NSLayoutConstraint? {
        var attrib = [NSLayoutConstraint.Attribute](arrayLiteral: .top)
        if inclMargin {
            attrib.append(.topMargin)
        }
        return getConstraintWithParent(attributes: attrib)
    }
    
    public func leadingConstraintWithParent(inclMargin: Bool = true) -> NSLayoutConstraint? {
        var attrib = [NSLayoutConstraint.Attribute](arrayLiteral: .leading)
        if inclMargin {
            attrib.append(.leadingMargin)
        }
        return getConstraintWithParent(attributes: attrib)
    }
    
    public func trailingConstraintWithParent(inclMargin: Bool = true) -> NSLayoutConstraint? {
        var attrib = [NSLayoutConstraint.Attribute](arrayLiteral: .trailing)
        if inclMargin {
            attrib.append(.trailingMargin)
        }
        return getConstraintWithParent(attributes: attrib)
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
    
    
    /// Will perform a slide view animation to bottom. If no top constraint exists to parent, will do nothing.
    /// Notice: you should probably set the width and the x aligment of the view before calling this function
    public func slideAnimateToBottom(animationDuration: TimeInterval = 0.5,
                                     completion: (() -> Void)? = nil) {
        slideAnimateToY(constant: frame.height,
                        usingParentTopConstraint: false,
                        animationDuration: animationDuration,
                        completion: completion)
    }
    
    
    /// Will perform a slide view animation to top. If no top constraint exists to parent, will do nothing.
    /// Notice: you should probably set the width and the x aligment of the view before calling this function. Also, make sure that the frame of the view is set correctly
    public func slideAnimateToTop(animationDuration: TimeInterval = 0.5,
                                  completion: (() -> Void)? = nil) {
        slideAnimateToY(constant: -frame.height,
                        usingParentTopConstraint: true,
                        animationDuration: animationDuration,
                        completion: completion)
    }
    
    /// Willl perform a slide animation to a given y point on screen.
    /// Notice: the animation made using moving the top constraint with the parent top. If you're expecting any weird behaviour notice that
    /// Also, you should probably set the width and the x aligment of the view before calling this function
    public func slideAnimateToY(constant: CGFloat,
                                usingParentTopConstraint: Bool = true,
                                animationDuration: TimeInterval = 0.5,
                                completion: (() -> Void)? = nil) {
        
        var constraint: NSLayoutConstraint? = nil
        if usingParentTopConstraint {
            if let viewTopConstr = getConstraintWithParent(attributes: [.top, .topMargin]) {
                constraint = viewTopConstr
            }
        } else {
            if let viewTopConstr = getConstraintWithParent(attributes: [.bottom, .bottomMargin]) {
                constraint = viewTopConstr
            }
        }
        if constraint == nil {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            guard let constraint = constraint else {return}
            constraint.constant = constant
            UIView.animate(withDuration: animationDuration, animations: {
                self.superview?.layoutIfNeeded()
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
    
    
    //// Will add a blurry effect to a view.
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
            blurEffectView.fadeIn()
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

    /// Will round all of the corners of a view
    public func roundAllCorners(radius: CGFloat = 10) {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    
    /// Will round the corners of a view
    public func roundCorners(corners: CACornerMask, radius: CGFloat = 10) {
        layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
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
    
    /// Will do a fade out effect on a view
    public func fadeOut(withDuration: TimeInterval = 0.5,
                        hideAtEnd: Bool = true,
                        delay: TimeInterval = 0,
                        toAlpha: CGFloat = 1,
                        _ completion: (() -> Void)? = nil) {
        fade(fromAlpha: alpha,
             toAlpha: 0,
             hideAtEnd: hideAtEnd,
             animationOptions: UIView.AnimationOptions.curveEaseOut,
             duration: withDuration,
             delay: delay,
             completion)
    }
    
    // Will do a fade in effect on a view
    public func fadeIn(withDuration: TimeInterval = 0.5,
                       hideAtEnd: Bool = false,
                       delay: TimeInterval = 0,
                       toAlpha: CGFloat = 1,
                       _ completion: (() -> Void)? = nil) {
        isHidden = false
        fade(fromAlpha: alpha,
             toAlpha: toAlpha,
             hideAtEnd: hideAtEnd,
             animationOptions: UIView.AnimationOptions.curveEaseIn,
             duration: withDuration,
             delay: delay,
             completion)
    }
    
    
    /// Will do a custom fade effect on a view
    public func fade(fromAlpha: CGFloat,
                     toAlpha: CGFloat,
                     hideAtEnd: Bool,
                     animationOptions: UIView.AnimationOptions,
                     duration: TimeInterval = 0.5,
                     delay: TimeInterval = 0,
                     _ completion: (() -> Void)? = nil) {
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
            self.alpha = toAlpha
        }, completion: { _ in
            self.isHidden = hideAtEnd
            completion?()
        })
    }
    
    /// Will update a constraint with it's parent
    public func animateUpdateConstraintWithParent(constraint: NSLayoutConstraint,
                                                  constant: CGFloat,
                                                  animateInterval: TimeInterval = 0.5,
                                                  _ completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            constraint.constant = constant
            guard let superview = self.superview else {
                fatalError("Make sure the superview attached before updating height via animation")
            }
            UIView.animate(withDuration: animateInterval, animations: {
                superview.layoutIfNeeded()
            }) { done in
                completion?()
            }
        }
    }
    
    

    /// Will rotate a view by specified degrees
    public func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
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
    
    /// Will put the view at the y center of the parent
    @discardableResult
    public func centralizeVerticalInParent(constant: CGFloat = 0,
                                           multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .centerY,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Will put the view at the x center of the parent
    @discardableResult
    public func centralizeHorizontalInParent(constant: CGFloat = 0,
                                             multiplier: CGFloat = 1) -> NSLayoutConstraint {
        var _constraint: NSLayoutConstraint
        if let constraint = getConstraintWithParent(attributes: [.centerX]) {
            constraint.isActive = true
            _constraint = constraint
        } else {
            _constraint = NSLayoutConstraint(item: self,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.superview!,
                                             attribute: .centerX,
                                             multiplier: multiplier,
                                             constant: constant)
            _constraint.isActive = true
        }
        return _constraint
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

// MARK: - UISegmentedControl
extension UISegmentedControl {
    
    /// Set the font for the unselected tab
    public func setUnselectedFont(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray) {
        let defaultAttributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    /// Set the font for the selected tab
    public func setSelectedFont(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red) {
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
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
    
    /// Will set a title for all of the button's states (normal, selected and disabled)
    public func setAllStatesColor(color: UIColor){
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .disabled)
    }
}

// MARK: - UILabel
extension UILabel {
    
    /// Will set attributed text to a label. To do so add all of your text in the text parameter while the attributed text should be in barckets, like so:
    /// text: "this is normal text text. [this is my attributed text] this isnt. [This is!]"
    public func setAttrbiutedText(text: String,
                                  normalTextFont: UIFont,
                                  normalTextColor: UIColor,
                                  attributedTextFont: UIFont,
                                  attributedTextColor: UIColor,
                                  lineSpacing: CGFloat = 3,
                                  alignment: NSTextAlignment = .center) {
        // iOS 12.0 issues...
        DispatchQueue.main.async {
            self.text = ""
            self.attributedText = nil
            self.text = text
            var startIdx = -1
            var endIdx = -1
            var counter = -1
            var boldStarted = false
            let fullAttString = NSMutableAttributedString()
            let boldAttribute = [NSAttributedString.Key.font : attributedTextFont,
                                 NSAttributedString.Key.foregroundColor: attributedTextColor]
            let regularAttribute = [NSAttributedString.Key.font : normalTextFont,
                                    NSAttributedString.Key.foregroundColor: normalTextColor]
            for char in text {
                
                counter += 1
                if char == "[" && !boldStarted {
                    boldStarted = true
                    startIdx = counter
                    continue
                }
                
                if char == "]" && boldStarted {
                    boldStarted = false
                    endIdx = counter
                    let boldiText = text.substring(startIdx + 1, endIdx)
                    let boldiString = NSMutableAttributedString(string: boldiText, attributes:boldAttribute)
                    fullAttString.append(boldiString)
                    continue
                }
                
                if !boldStarted {
                    let regularString = NSMutableAttributedString(string: String(char), attributes:regularAttribute)
                    fullAttString.append(regularString)
                }
            }
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = alignment
            fullAttString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: fullAttString.string.count))
            self.attributedText = fullAttString
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

// MARK: - UITextInput
extension UITextInput {
    
    /// Will move the caret to the start of the line
    public func moveCaretToLineStart() {
        self.selectedTextRange = self.textRange(from: beginningOfDocument,
                                                to: beginningOfDocument)
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
    
    /// Will centralize horizontal scrollbar in center
    public func centralizeHorizontalScrollbar() {
        let centerX = contentSize.width / 2 - bounds.size.width / 2
        setContentOffset(CGPoint(x: centerX, y: contentOffset.y), animated: false)
    }
    
    /// Will centralize vertical scrollbar in center
    public func centralizeVerticalScrollbar() {
        let centerY = contentSize.height / 2 - bounds.size.height / 2
        setContentOffset(CGPoint(x: contentOffset.x, y: centerY), animated: false)
    }
    
    /// Will centralize both scrollbars in center
    public func centralizeScrollbars() {
        let centerY = contentSize.height / 2 - bounds.size.height / 2
        let centerX = contentSize.width / 2 - bounds.size.width / 2
        setContentOffset(CGPoint(x: centerX, y: centerY), animated: false)
    }
    
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
    
    public var minContentOffset: CGPoint {
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top)
    }
    
    public var maxContentOffset: CGPoint {
        return CGPoint(
            x: contentSize.width - bounds.width + contentInset.right,
            y: contentSize.height - bounds.height + contentInset.bottom)
    }
    
    /// Scroll to start of content
    public func scrollToMinContentOffset(animated: Bool) {
        setContentOffset(minContentOffset, animated: animated)
    }
    
    /// Scroll to end of content
    public func scrollToMaxContentOffset(animated: Bool) {
        setContentOffset(maxContentOffset, animated: animated)
    }
}

// MARK: - UITextView
extension UITextView {
    
    /// Will set attributed text to a label. To do so add all of your text in the text parameter while the attributed text should be in barckets, like so:
    /// text: "this is normal text text. [this is my attributed text] this isnt. [This is!]"
    /// Also, this function can make certain text clickable. To use the clickable values, listen to change in the TextViewDelegate URL methods. For more info, see:
    /// UIClickableTextView implementation
    public func setAttrbiutedText(text: String,
                                  normalTextFont: UIFont,
                                  normalTextColor: UIColor,
                                  attributedTextFont: UIFont,
                                  attributedTextColor: UIColor,
                                  lineSpacing: CGFloat = 3,
                                  alignment: NSTextAlignment = .center,
                                  clickable: Bool = true) {
        // iOS 12.0 issues...
        DispatchQueue.main.async {
            self.isSelectable = true
            self.isEditable = false
            self.dataDetectorTypes = .link
            self.text = ""
            self.attributedText = nil
            self.text = text
            var startIdx = -1
            var endIdx = -1
            var counter = -1
            var boldStarted = false
            let fullAttString = NSMutableAttributedString()
            let boldAttribute = [NSAttributedString.Key.font : attributedTextFont,
                                 NSAttributedString.Key.foregroundColor: attributedTextColor]
            let regularAttribute = [NSAttributedString.Key.font : normalTextFont,
                                    NSAttributedString.Key.foregroundColor: normalTextColor]
            for char in text {
                
                counter += 1
                if char == "[" && !boldStarted {
                    boldStarted = true
                    startIdx = counter
                    continue
                }
                
                if char == "]" && boldStarted {
                    boldStarted = false
                    endIdx = counter
                    let boldiText = text.substring(startIdx + 1, endIdx)
                    let boldiString = NSMutableAttributedString(string: boldiText, attributes:boldAttribute)
                    fullAttString.append(boldiString)
                    if clickable {
                        let clickableValue = boldiText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? boldiText
                        fullAttString.addAttribute(.link,
                                                   value: clickableValue,
                                                   range: NSRange(location: fullAttString.length - boldiText.count,
                                                                  length: boldiText.count)
                        )
                    }
                    continue
                }
                
                if !boldStarted {
                    let regularString = NSMutableAttributedString(string: String(char), attributes:regularAttribute)
                    fullAttString.append(regularString)
                }
            }
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = alignment
            fullAttString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: fullAttString.string.count))
            self.attributedText = fullAttString
        }
    }
    
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

    
    /// Will update the uitextview height by it's width and content
    @discardableResult
    public func updateAndGetTextViewHeight() -> CGFloat {
        let sizeToFitIn = CGSize(width: frame.width, height: CGFloat(MAXFLOAT))
        let newSize = sizeThatFits(sizeToFitIn)
        heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        return newSize.height
    }
    
}

// MARK: - UIImage
extension UIImage {
    
    // will create an image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // will dim a uiimage
    public func dim(with factor: CGFloat? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        draw(in: rect)
        let darkColor = UIColor.black.withAlphaComponent(0.2)
        darkColor.setFill()
        UIRectFillUsingBlendMode(rect, .sourceAtop)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - UICollectionView
public extension UICollectionView {
    
    /// Will return the horizontal padding between cells
    func getHorizontalSpacing(cellWidth: CGFloat) -> CGFloat {
            let collectionViewWidth = frame.width
            let numberOfCellsPerRow = floor(collectionViewWidth / cellWidth)
            let totalCellWidth = cellWidth * numberOfCellsPerRow
            let horizontalSpacing = (collectionViewWidth - totalCellWidth) / (numberOfCellsPerRow + 1)
            print(horizontalSpacing)
            return horizontalSpacing
    }
    
    /// Will return the width of the content in the collection view
    func getContentWidth() -> CGFloat {
        return frame.width - contentInset.left - contentInset.right
    }
    
    /// Will return the height of the content in the collection view
    func getContentHeight() -> CGFloat {
        return frame.height - contentInset.top - contentInset.bottom
    }
}
