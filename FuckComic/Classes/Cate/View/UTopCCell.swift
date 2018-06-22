//
//  UTopCCell.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/22.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class UTopCCell: UBaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iconV = UIImageView()
        iconV.contentMode = .scaleAspectFill
        return iconV
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    var model: TopModel? {
        didSet {
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover)
        }
    }
}
