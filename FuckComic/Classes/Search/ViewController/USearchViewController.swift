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
    private var comics: [ComicModel]?
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(noti:)), name: .UITextFieldTextDidChange, object: sr)
        return sr
    }()
    
    private lazy var historyTable: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: UBaseTableViewCell.self)
        tableView.register(headerFooterViewType: USearchHead.self)
        tableView.register(headerFooterViewType: USearchTFoot.self)
        return tableView
    }()
    
    lazy var searchTableView: UITableView = {
        let searchTB = UITableView(frame: CGRect.zero, style: .grouped)
        searchTB.delegate = self
        searchTB.dataSource = self
        searchTB.register(cellType: UBaseTableViewCell.self)
        searchTB.register(headerFooterViewType: USearchHead.self)
        return searchTB
    }()
    
    lazy var resultTableView: UITableView = {
        let resultTB = UITableView(frame: CGRect.zero, style: .grouped)
        resultTB.delegate = self
        resultTB.dataSource = self
        resultTB.register(cellType: UComicCell.self)
        
        return resultTB
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHistory()
    }
    
    private func loadHistory() {
        historyTable.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        ApiProvider.request(UApi.searchHot, model: HotItemsModel.self) { (resultData) in
            self.hotItem = resultData?.hotItems
            self.resultTableView.reloadData()
        }
    }
    private func searchRelative(_ text: String) {
        if text.count > 0 {
            historyTable.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            ApiProvider.request(UApi.searchRelative(inputText: text), model:[SearchItemModel].self) { (resultData) in
                self.relative = resultData
                self.searchTableView.reloadData()
            }
        }else{
            historyTable.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    private func searchResult(_ text: String) {
        if text.count > 0 {
            historyTable.isHidden = true
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            searchBar.text = text
            ApiLoadingProvider.request(UApi.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (resultData) in
                self.comics = resultData?.comics
                self.resultTableView.reloadData()
            }
            let defaults = UserDefaults.standard
            var history = defaults.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
            history.removeAll()
            history.insert(text, at: 0)
            
            searchHistory = history
            historyTable.reloadData()
            
            defaults.set(searchHistory, forKey: String.searchHistoryKey)
            defaults.synchronize()
            
        }else {
            historyTable.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    override func configUI() {
        view.addSubview(historyTable)
        historyTable.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        
        searchBar.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancleAction))
    }
    
    @objc func cancleAction() {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
}

extension USearchViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(noti:Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

extension USearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTable {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTable {
            return section == 0 ? (searchHistory?.prefix(5).count ?? 0) : 0
        }else if tableView == searchTableView {
            return relative?.count ?? 0
        }else {
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        }else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTable {
            let  cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            return cell
        }else if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        }else if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicCell.self)
            cell.model = comics?[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTable {
            searchResult(searchHistory[indexPath.row])
        }else if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        }else if tableView == resultTableView {
            guard let model = comics?[indexPath.row] else { return }
            let vc = UComicViewController(comicid: model.comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTable {
            return 44
        }else if tableView == searchTableView {
            return comics?.count ?? 0 > 0 ? 44: CGFloat.leastNormalMagnitude
        }else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTable {
            let head = tableView.dequeueReusableHeaderFooterView()
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

































