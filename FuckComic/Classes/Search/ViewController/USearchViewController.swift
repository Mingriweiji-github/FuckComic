//
//  USearchViewController.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/13.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import Foundation
import Moya

class USearchViewController: BaseViewController {
    
    private var currentRequest: Cancellable?
    private var hotItem: [SearchItemModel]?
    private var relative: [SearchItemModel]?
    private var comic: [ComicModel]?
    
    private lazy var searchHistory : [String]! = {
      return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    
    lazy var searchBar: UITextField = {
        let sr = UITextField()
        sr.backgroundColor = UIColor.white
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = UIFont.systemFont(ofSize: 15)
        sr.placeholder = "输入漫画名称/作者"
        sr.layer.cornerRadius = 15
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        sr.leftViewMode = .always
        sr.clearsOnBeginEditing = true
        sr.clearButtonMode = .whileEditing
        sr.delegate = self
        sr.returnKeyType = .search
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(), name: .UITextFieldTextDidChange, object: sr)
    }()
    
    private lazy var historyTable: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        tableView.register(cellType: UbaseTableViewCell.self)
        tableView.register(headerFooterViewType: USearchHead.self)
        tableView.register(headerFooterViewType: USearchTFoot.self)
        return tableView
    }()
    
    lazy var searchTableView: UITableView = {
        let searchTB = UITableView(frame: CGRect.zero, style: .grouped)
        searchTB.delegate = self as? UITableViewDelegate
        searchTB.dataSource = self as? UITableViewDataSource
        searchTB.register(cellType: )
        return <#value#>
    }()
    
    
    
}

extension USearchViewController: UITextFieldDelegate {
    
    @objc func textFieldTextDidChange(noti:Notification) {
    guard let textField = noti.object as? UITextField,let text = textField.text else { return }
        
    }
}
