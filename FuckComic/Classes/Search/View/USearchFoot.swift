//
//  USearchFoot.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/13.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class USearchCCell:UBaseCollectionViewCell  {
    lazy var titleLabel: UILabel = {
        let tl = UILabel ()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.darkGray
        return tl
    }()
    
    override func configUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 20, 10, 20))
        }
    }
    
}

class USearchTFoot: UBaseTableHeaderFooterView {
    weak var delegate: USearchTFootDelegate?
    
    private var didSelectIndexClosure: USearchTFootDidSelectIndexClosure?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewAlignedLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.horizontalAlignment = .left
        layout.estimatedItemSize = CGSize(width: 100, height: 60)
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.delegate = self as? UICollectionViewDelegate
        cw.dataSource = self as? UICollectionViewDataSource
        cw.register(cellType: USearchCCell.self)
        
        return cw
    }()
    
    var data: [SearchItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
}
typealias USearchTFootDidSelectIndexClosure = (_ index: Int, _ model: SearchItemModel) -> Void

protocol USearchTFootDelegate: class {
    func searchTFoot(_ searchFoot: USearchTFoot, didSelectItemAt index: Int, _ model: SearchItemModel)
}

extension USearchTFoot: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: USearchCCell.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.titleLabel.text = data[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTFoot(self, didSelectItemAt: indexPath.row, data[indexPath.row])
        
        guard let closure = didSelectIndexClosure else { return }
        
        closure(indexPath.row, data[indexPath.row])
    }
    
    func didSelectIndexClosure(_ closure: @escaping USearchTFootDidSelectIndexClosure) {
        didSelectIndexClosure = closure
    }    
}
