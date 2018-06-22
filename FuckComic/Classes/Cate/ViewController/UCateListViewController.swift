//
//  UCateListViewController.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/22.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit
import MJRefresh

class UCateListViewController: BaseViewController {
    private var searchString = ""
    private var topList = [TopModel]()
    private var rankList = [RankingModel]()
    
    lazy var searchButton: UIButton = {
        let sn = UIButton(type: .system)
        sn.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 20, height: 30)
        sn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sn.layer.cornerRadius = 15
        sn.setTitleColor(.white, for: .normal)
        sn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        sn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        sn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        return sn
    }()
    
    @objc func searchAction() {
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }
    
   private lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        fl.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: fl)
        cv.backgroundColor = UIColor.white
        cv.delegate = self as? UICollectionViewDelegate
        cv.dataSource = self as? UICollectionViewDataSource
        cv.alwaysBounceVertical = true
        cv.register(cellType: URankCCell.self)
        cv.register(cellType: UTopCCell.self)
        cv.uHead = URefreshHeader{ [weak self] in self?.loadData()}
        cv.uempty = UEmptyView { [weak self] in self?.loadData() }
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    private func loadData() {
        ApiLoadingProvider.request(UApi.cateList, model: CateListModel.self) { (returnData) in
            self.collectionView.uempty?.allowShow = true
            self.searchString = returnData?.recommendSearch ?? ""
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            self.collectionView.uHead.endRefreshing()
        }
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
    
}

extension UCateListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.prefix(3).count
        }else{
            return rankList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UTopCCell.self)
            cell.model = topList[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: URankCCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, section == 0 ? 0 : 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(kScreenWidth - 40) / 3)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = topList[indexPath.row]
            var titles : [String] = []
            var vcs: [UIViewController] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitle = tab.tabTitle else { continue }
                
                titles.append(tabTitle)
                vcs.append(UComicListViewController(argCon: tab.argCon, argName: tab.argName, argValue: tab.argValue))
            }
            
            let vc = UPageViewController(titles: titles, vcs: vcs, pagestyles: .topTabBar)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            let model = rankList[indexPath.row]
            let vc = UComicListViewController(argCon: model.argCon,
                                              argName: model.argName,
                                              argValue: model.argValue)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
































