//
//  BottomInformationDialogView.swift
//  GeneralRemoteiOS
//
//  Created by Oz Shabat on 05/09/2021.
//  Copyright © 2021 osApps. All rights reserved.
//

import UIKit
import OsTools

public class UIFloatingTableView: UIView {
    
    // instances
    var itemsStore: ItemsStore<GenericListItem> = ItemsStore()
    var tempItemsHolder = [GenericListItem]()
    
    // views
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var contentHolderView: UIView!
    @IBOutlet public weak var tableView: UITableView!
    
    // design
    public var gapBetweenItems: CGFloat = 15
    public var itemLabelFont: UIFont = .systemFont(ofSize: 15)
    public var itemImageSize: CGFloat = 24
    public var itemLabelTextColor: UIColor = .black
    
    // if you have an item which you want to mark as selected, set it here, before adding any items
    private var selectedItem: GenericListItem? = nil
    
    /// Override this to get the selected item and a boolean indicating if it already was the selected item
    public var itemDidTap: ((GenericListItem, Bool) -> ())? = nil
    
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
        Bundle.main.loadNibNamed("UIFloatingTableView", owner: self, options: nil);
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setConstraints(contentView: contentView)
//        layer.cornerRadius = 20
        tag = UIFloatingTableView.TAG
//        layer.masksToBounds = true
        setTableView()
        
//        contentView.layer.cornerRadius = 25
//        contentView.layer.masksToBounds = false
//        contentView.clipsToBounds = false
//        
//        contentHolderView.layer.cornerRadius = 25
//        contentHolderView.layer.masksToBounds = false
//        contentHolderView.clipsToBounds = false
//        
//        tableView.layer.cornerRadius = 25
//        tableView.layer.masksToBounds = false
//        tableView.clipsToBounds = false
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
    
    public func addItem(item: GenericListItem, selected: Bool = false) {
        if selected {
            self.selectedItem = item
        }
        tempItemsHolder.append(item)
    }
    
    
    /// Will pop open the dialog
    public func pop(parentView: UIView,
                    anchorView: UIView,
                    width: CGFloat? = nil) {
        
        parentView.addSubview(self)
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        var desiredWidth: CGFloat
        if let width = width {
            desiredWidth = width
        } else {
            desiredWidth = anchorView.frame.width
        }
        
        if desiredWidth > Tools.getWindowWidth() {
            desiredWidth = Tools.getWindowWidth()
        }
        
        setWidth(width: desiredWidth)
        
        tableView.rowHeight = 70
        tableView.estimatedRowHeight = 70

        
        // currently, not fail proof against big dialog, bigger than screen size
        let itemCount = CGFloat(tempItemsHolder.count)
        
        setHeight(height: itemCount * tableView.rowHeight)    // height

        topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: 15).isActive = true
        leftAnchor.constraint(equalTo: anchorView.leftAnchor, constant: 0).isActive = true
        addItems(items: tempItemsHolder)
        
        // todo:
        tempItemsHolder.removeAll()
        
        fadeIn(withDuration: 0.25){}
        
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        fadeOut {
            self.removeFromSuperview()
            completion?()
        }
    }
}


// MARK: - TableView delegate
extension UIFloatingTableView: UITableViewDelegate, UITableViewDataSource {
    
    // instances
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "UIFloatingTableViewCellView", bundle: nil), forCellReuseIdentifier: "UIFloatingTableViewCellView")
    }
    
    /// Will add an item to the list
    private func addItems(items: [GenericListItem]) {
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
    
    
    //append values, one by one
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIFloatingTableViewCellView", for: indexPath) as! UIFloatingTableViewCellView
        let listItem = itemsStore.getItemAt(indexPath.row)!
        cell.titleLabel.text = listItem.name
        print("showing: \(listItem.name)")
        cell.titleLabel.font = itemLabelFont
        cell.titleLabel.textColor = itemLabelTextColor
        // show selected iv
        if let selectedItem = selectedItem,
           listItem.name == selectedItem.name {
            cell.selectedItemIV.hide(false)
            cell.ivHeight.constant = itemImageSize
            cell.ivWidth.constant = itemImageSize
        } else {
            cell.selectedItemIV.hide(true)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = itemsStore.getItemAt(indexPath.row) else {return}
        
        dismiss()
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

