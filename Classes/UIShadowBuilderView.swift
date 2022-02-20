//
//  UIShadowBuilder.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/01/2022.
//  Copyright © 2022 osApps. All rights reserved.
//

import Foundation
import UIKit

/// This view will help with building a suitable shadow for a view/s.
/// To use, just add this view to your view controller via the IB and drag and views to the viewList outlet in the insepctor.
/// Optional: if you want to add an identifier to the view, add a space separated string to this view in the IB
public class UIShadowBuilderView: UIView {
    
    // views
    @IBOutlet weak var sv: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shadowContainer: UIView!
    @IBOutlet var contentView: UIView!
    
    // lables
    @IBOutlet var currViewLabel: UILabel!
    @IBOutlet var opacityValueLabel: UILabel!
    @IBOutlet var offsetXValueLabel: UILabel!
    @IBOutlet var offsetYValueLabel: UILabel!
    @IBOutlet var radiusValueLabel: UILabel!
    @IBOutlet var grayscaleValueLabel: UILabel!
    
    // sliders
    @IBOutlet weak var grayscaleSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var offsetXSlider: UISlider!
    @IBOutlet weak var offsetYSlider: UISlider!
    
    @IBOutlet weak var svWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var svHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var parentViewWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeightConstr: NSLayoutConstraint!
    
    /// Will hold the views to build the shadow
    @IBOutlet public var viewList: [UIView]! = [UIView]() {
        didSet {
            setCurrView()
        }
    }
    
    /// Will hold a list of identifiers for the views.
    /// Add a bunch of identifiers here, separated by a space
    @IBInspectable public var viewIdList: String = "" {
        didSet {
            let lst = viewIdList.components(separatedBy: " ")
            addIdentifiers(identifierList: lst)
        }
    }
    
    // indications
    public var currViewIdx = 0
    private var identifierList = [String]()
    private var currView: UIView!
    
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
    
    private func commonInit() {
        
        let bundle = Bundle(for: UIShadowBuilderView.self)
        bundle.loadNibNamed("UIShadowBuilderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setConstraints(contentView: contentView)
        
        // take the parent size (currently the content view matches it)
        let parentViewHeight = contentView.frame.height
        let parentViewWidth = contentView.frame.width
        
        // set parent size
        parentViewWidthConstr.constant = parentViewWidth
        parentViewHeightConstr.constant = parentViewHeight
        
        // set stack view size to match it's content
        svWidthConstr.constant = sv.frame.width
        svHeightConstr.constant = sv.frame.height
        
        setInitialLabels()
    }
    
    private func setInitialLabels() {
        setLabelBySlider(slider: grayscaleSlider, label: grayscaleValueLabel)
        setLabelBySlider(slider: radiusSlider, label: radiusValueLabel)
        setLabelBySlider(slider: opacitySlider, label: opacityValueLabel)
        setLabelBySlider(slider: offsetXSlider, label: offsetXValueLabel)
        setLabelBySlider(slider: offsetYSlider, label: offsetYValueLabel)
    }
    
    /// will adjust the constraints of the custom view to be at the right place you
    /// set it in the storyboard (connecting the constraints to their right locations)
    private func setConstraints(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentView.superview!.bottomAnchor).isActive = true
    }
    
    
    /// This is the code option to add a bunch of views whom require shadows
    public func addViews(views: [UIView], identifierList: [String]? = nil) {
        if viewList == nil {
            viewList = [UIView]()
        }
        viewList.append(contentsOf: views)
        if let identifierList = identifierList {
            addIdentifiers(identifierList: identifierList)
        }
        setCurrView()
    }
    
    /// This is the code option to add a bunch of identifiers for the views whom require shadows
    public func addIdentifiers(identifierList: [String]) {
        self.identifierList.append(contentsOf: identifierList)
    }
    
    private func setCurrView() {
        currView = viewList[currViewIdx]
        var currViewName: String
        if identifierList.count != 0 {
            currViewName = identifierList[currViewIdx]
        } else {
            currViewName = String(describing: type(of: currView))
        }
        currViewLabel.text = currViewName
    }
    
    
    @IBAction func sliderDidValueChanged(_ sender: UISlider) {
        var valueLabel: UILabel
        switch sender.tag {
        case 1: valueLabel = radiusValueLabel
        case 2: valueLabel = offsetXValueLabel
        case 3: valueLabel = offsetYValueLabel
        case 4: valueLabel = opacityValueLabel
        case 5: valueLabel = grayscaleValueLabel
        default: fatalError("What is dis tag?")
        }
        
        setLabelBySlider(slider: sender, label: valueLabel)
        updateShadow()
    }
    
    private func setLabelBySlider(slider: UISlider, label: UILabel) {
        let fullNum = sliderValueToShortFloat(slider: slider)
        label.text = "(\(fullNum))"
    }
    
    private func sliderValueToShortFloat(slider: UISlider) -> String {
        let numberAsString = String(slider.value)
        
        var fullNum: String
        
        // cut by 2 decimal points, that's enough
        if numberAsString.count > 4,
           let dotIdx = numberAsString.firstIndexOf(string: ".") {
            let firstLetters = numberAsString[0...dotIdx]
            var nextLetters: String = "00"
            
            if numberAsString.count > dotIdx + 2 {
                nextLetters = numberAsString[dotIdx...dotIdx + 2]
            }
            
            if nextLetters.starts(with: ".") {
                nextLetters = String(nextLetters.dropFirst())
            }
            
            fullNum = firstLetters + nextLetters
        } else {
            if numberAsString == "0.0" {
                fullNum = "0"
            } else {
                fullNum = "\(slider.value)"
            }
        }
        return fullNum
    }
    
    /// Will implement the shadow
    private func updateShadow() {
        currView.dropShadow(masksToBounds: false,
                            clipsToBounds: false,
                            color: UIColor(red: CGFloat(grayscaleSlider.value),
                                           green: CGFloat(grayscaleSlider.value),
                                           blue: CGFloat(grayscaleSlider.value), alpha: 1.0).cgColor,
                            offset: CGSize(width: CGFloat(offsetXSlider.value),
                                           height: CGFloat(offsetYSlider.value)),
                            opacity: Float(opacitySlider.value),
                            radius: CGFloat(radiusSlider.value))
    }
    
    // Switch to the next view
    @IBAction func nextViewDidTap(_ sender: Any) {
        currViewIdx += 1
        if currViewIdx >= viewList.count {
            currViewIdx = 0
        }
        setCurrView()
        
    }
    
    // Printing...
    @IBAction func printDidTap(_ sender: Any) {
        //        let cleanOffset = offsetXValueLabel.text!.replace("(", "").replace(")", "").digits
        
        print("""
**********************************
UIView: \(currViewLabel.text!),
UIColor: UIColor(red: \(sliderValueToShortFloat(slider: grayscaleSlider)),
                 green: \(sliderValueToShortFloat(slider: grayscaleSlider)),
                 blue: \(sliderValueToShortFloat(slider: grayscaleSlider)),
                 alpha: 1.0
Offset: CGSize(width: \(offsetXValueLabel.text!.digitsWithDecimal), height: \(offsetYValueLabel.text!.digitsWithDecimal)),
Opacity: \(opacityValueLabel.text!.digitsWithDecimal),
Radius: \(radiusValueLabel.text!.digitsWithDecimal)
**********************************
""")
    }
    
    
    @IBAction func assignPrintDidTap(_ sender: Any) {
        let currGrayscale = sliderValueToShortFloat(slider: grayscaleSlider)
        let colorLine = "UIColor(red: \(currGrayscale), green: \(currGrayscale), blue: \(currGrayscale), alpha: 1.0).cgColor"
        let offsetLine = "CGSize(width: \(offsetXValueLabel.text!.digitsWithDecimal), height: \(offsetYValueLabel.text!.digitsWithDecimal))"
        print("""
        \(currViewLabel.text!).dropShadow(
        masksToBounds: false,
        clipsToBounds: false,
        color: \(colorLine),
        offset: \(offsetLine),
        opacity: \(opacityValueLabel.text!.digitsWithDecimal),
        radius: \(radiusValueLabel.text!.digitsWithDecimal)
        )
        """)
    }
}
