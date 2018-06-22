//
//  URankCCell.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/22.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class URankCCell: UBaseCollectionViewCell {
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        return title
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: RankingModel? {
     
        didSet{
            guard let model = model else {
                return
            }
            
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = model.sortName
        }
        
    }
    
    
}
