//
//  BottomInformationDialogView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import UIKit
import OsTools


/**
 A dynamically made tableview which can be attached anywhere.
 When popping, select to which parent view to get attached to and to which anchor (to left or right of it)
 */
public class UIFloatingTableView: UIView {
    
    // instances
    var itemsStore: ItemsStore<FloatingTableViewItem> = ItemsStore()
    var tempItemsHolder = [FloatingTableViewItem]()
    
    // views
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var contentHolderView: UIView!
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet weak var trailingConstr: NSLayoutConstraint!
    @IBOutlet weak var leadingConstr: NSLayoutConstraint!
    
    // tableview design
    public var extraWidth: CGFloat = 0   // add here extra width to the table view if you wish
    
    // general item design
    public var itemLabelFont: UIFont = .systemFont(ofSize: 15)
    public var itemOptionalIVSize: CGFloat = 24
    public var itemLabelTextColor: UIColor = .black
    public var itemRowHeight: CGFloat = 50
    
    // selected item indicator
    public var selectedItemIndicatorIVHeight: CGFloat = 20
    public var newItemIndicatorHeight: CGFloat = 10
    public var selectedItemIndicatorImage: UIImage? = nil
    
    // selected text
    public var selectedItemLabelTextColor: UIColor = .black
    public var selectedItemLabelFont: UIFont = .systemFont(ofSize: 15)
    
    // indications
    private var selectedItem: FloatingTableViewItem? = nil
    private var newItems = [FloatingTableViewItem]()
    private var widthConstr: NSLayoutConstraint!    // will be set after pop
    private var addedOptionalIVWidth = false
    private var addedSelectedIndiactorIVWidth = false
    private var addedNewItemIndicatorIVWidth = false
    private var lineAboveCellIdx: Int? = nil
    
    /// Override this to get the selected item and a boolean indicating if it already was the selected item
    public var itemDidTap: ((FloatingTableViewItem, Bool) -> ())? = nil
    
    // finals
    public static let TAG = 6565
    
    /// init option 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// init option 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    /// shared init to set contraints
    private func commonInit() {
        let bundle = Bundle(for: UIFloatingTableView.self)
        bundle.loadNibNamed("UIFloatingTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setConstraints(contentView: contentView)
        tag = UIFloatingTableView.TAG
        setTableView()
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
    
    public func addItem(item: FloatingTableViewItem,
                        selected: Bool = false,
                        newItem: Bool = false) {
        
        if selected {
            self.selectedItem = item
        }
        if newItem {
            self.newItems.append(item)
        }
        tempItemsHolder.append(item)
    }
    
    public func addLineAbove(itemPosition position: Int) {
        self.lineAboveCellIdx = position
    }
    
    
    /// Will pop open the dialog
    public func pop(parentView: UIView,
                    anchorView: UIView,
                    toLeftAnchor: Bool = true) {
        
        parentView.addSubview(self)
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        setInitialWidth()
        tableView.rowHeight = itemRowHeight
        tableView.estimatedRowHeight = itemRowHeight
        
        
        // currently, not fail proof against big dialog, bigger than screen size
        let itemCount = CGFloat(tempItemsHolder.count)
        
        setHeight(height: itemCount * tableView.rowHeight)    // height
        
        topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: 15).isActive = true
        if toLeftAnchor {
            leftAnchor.constraint(equalTo: anchorView.leftAnchor, constant: 0).isActive = true
        } else {
            rightAnchor.constraint(equalTo: anchorView.rightAnchor, constant: 0).isActive = true
        }
        addItems(items: tempItemsHolder)
        
        // todo:
        tempItemsHolder.removeAll()
        
        Task {@MainActor [weak self] in
            await self?.fadeIn(withDuration: 0.25)
        }
    }
    
    @MainActor
    public func dismiss() async {
        await fadeOut()
        self.removeFromSuperview()
    }
    
    private func setInitialWidth() {
        // calculate title size
        var longesTitle = ""
        tempItemsHolder.forEach { it in
            if it.name.count > longesTitle.count {
                longesTitle = it.name
            }
        }
        
        let fontAttributes = [NSAttributedString.Key.font: itemLabelFont]
        let size = (longesTitle as NSString).size(withAttributes: fontAttributes)
        
        let titleWidth = ceil(size.width)
        
        let totalSize = titleWidth + leadingConstr.constant + trailingConstr.constant + extraWidth
        widthConstr = setWidth(width: totalSize)
    }
}


// MARK: - TableView delegate
extension UIFloatingTableView: UITableViewDelegate, UITableViewDataSource {
    
    // instances
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let bundle = Bundle(for: UIFloatingTableView.self)
        let nib = UINib(nibName: "UIFloatingTableViewCellView", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "UIFloatingTableViewCellView")
    }
    
    /// Will add an item to the list
    private func addItems(items: [FloatingTableViewItem]) {
        var indexPaths = [IndexPath]()
        items.forEach { item in
            self.itemsStore.addItem(item)
            indexPaths.append(IndexPath(row: itemsStore.count()-1, section: 0))
        }
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        refreshList(tableView: tableView)
        tableView.endUpdates()
    }
    
    
    // append values, one by one
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIFloatingTableViewCellView", for: indexPath) as! UIFloatingTableViewCellView
        let listItem = itemsStore.getItemAt(indexPath.row)!
        cell.titleLabel.text = listItem.name
        cell.titleLabel.font = itemLabelFont
        cell.titleLabel.textColor = itemLabelTextColor
        
        var widthToAdd: CGFloat = 0
        
        // selected iv indicator
        if let selectedItem = selectedItem,
           listItem.name == selectedItem.name,
           let itemImage = selectedItemIndicatorImage {
            cell.titleLabel.textColor = selectedItemLabelTextColor
            cell.titleLabel.font = selectedItemLabelFont
            cell.selectedItemIndicatorIV.hide(false)
            cell.selectedItemIVHeight.constant = selectedItemIndicatorIVHeight
            cell.selectedItemIndicatorIV.image = itemImage
            
            if !addedSelectedIndiactorIVWidth {
                addedSelectedIndiactorIVWidth = true
                widthToAdd += cell.selectedItemIVHeight.constant
                widthToAdd += cell.parentSV.spacing
            }
            
        } else {
            cell.selectedItemIndicatorIV.hide(true)
        }
        
        // new iv indicator
        if newItems.contains(where: {$0.name == listItem.name }) {
            cell.newItemIndicatorView.hide(false)
            //            cell.selectedItemIVHeight.constant = newItemIndicatorHeight
            //            if !addedNewItemIndicatorIVWidth {
            //                addedNewItemIndicatorIVWidth = true
            //                widthToAdd += cell.newItemIndicatorIVHeight.constant
            //                widthToAdd += cell.parentSV.spacing
            //            }
        } else {
            cell.newItemIndicatorView.hide(true)
        }
        
        
        
        if let imageName = listItem.imageName {
            cell.optionalIV.hide(false)
            cell.optionalIV.image = UIImage(named: imageName)
            cell.optionalIVSize.constant = itemOptionalIVSize
            
            // add to whole width
            if !addedOptionalIVWidth {
                addedOptionalIVWidth = true
                widthToAdd += cell.optionalIVSize.constant
                widthToAdd += cell.titleSV.spacing
            }
            
        } else {
            cell.optionalIV.hide(true)
        }
        
        if widthToAdd != 0 {
            widthConstr.constant += widthToAdd
        }
        //        updateWidthIfRequired(cell: cell, item: listItem)
        
        // set line above cell index
        if let lineAboveCellIdx = lineAboveCellIdx, lineAboveCellIdx == indexPath.row {
            cell.lineView.isHidden = false
            cell.titleLabel.textColor = #colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
            cell.lineViewDistanceToTop.constant = 6
            cell.titleLabel.textAlignment = .center
        } else {
            cell.lineViewDistanceToTop.constant = 0
            cell.lineView.isHidden = true
            cell.titleLabel.textAlignment = .natural
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    /// If contains iv or indicator, will update width of the whole table view here
    private func updateWidthIfRequired(cell: UIFloatingTableViewCellView, item: FloatingTableViewItem) {
        
        var widthToAdd: CGFloat = 0
        var shouldUpdateWidth = false
        
        if !cell.optionalIV.isHidden {
            if !addedOptionalIVWidth {
                addedOptionalIVWidth = true
                shouldUpdateWidth = true
                widthToAdd += cell.optionalIVSize.constant
                widthToAdd += cell.titleSV.spacing
            }
        }
        
        if !cell.selectedItemIndicatorIV.isHidden {
            if !addedSelectedIndiactorIVWidth {
                addedSelectedIndiactorIVWidth = true
                shouldUpdateWidth = true
                widthToAdd += cell.selectedItemIVHeight.constant
                widthToAdd += cell.parentSV.spacing
            }
        }
        
        
        //        if !cell.newItemIndicatorView.isHidden {
        //            if !addedSelectedIndiactorIVWidth {
        //                addedSelectedIndiactorIVWidth = true
        //                shouldUpdateWidth = true
        //                widthToAdd += cell.selectedItemIVHeight.constant
        //                widthToAdd += cell.parentSV.spacing
        //            }
        //        }
        
        
        if shouldUpdateWidth {
            widthConstr.constant = widthToAdd
        }
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = itemsStore.getItemAt(indexPath.row) else {return}
        
        Task {[weak self] in
            guard let self = self else {return}
            await dismiss()
        }
        itemDidTap?(item, item.id == selectedItem?.id)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsStore.count()
    }
    
    func clearAllItems(tableView: UITableView){
        itemsStore.clearAllItems()
        refreshList(tableView: tableView)
    }
    
    func refreshList(tableView: UITableView) {
        tableView.reloadData()
    }
}

public struct FloatingTableViewItem {
    public var name: String
    public var imageName: String?
    public var id: String?
    
    public init(name: String, id: String? = nil, imageName: String? = nil) {
        self.name = name
        self.id = id
        self.imageName = imageName
    }
}
