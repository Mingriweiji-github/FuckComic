
//
//  UComicCell.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/15.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class UComicCell: UbaseTableViewCell {
    var spinnerName: String?
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.black
        return title
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subTitle = UILabel()
        subTitle.textColor = UIColor.gray
        subTitle.font = UIFont.systemFont(ofSize: 14)
        return subTitle
    }()
    
    lazy var desLabel: UILabel = {
        let describtion = UILabel()
        describtion.textColor = UIColor.gray
        describtion.numberOfLines = 3
        describtion.font = UIFont.systemFont(ofSize: 14)
        return describtion
    }()
    
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.textColor = UIColor.orange
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        return tagLabel
    }()
    
    lazy var orderView: UIImageView = {
        let orderV = UIImageView()
        orderV.contentMode = .scaleAspectFit
        return orderV
    }()
    
    override func configUI() {
       separatorInset = .zero
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 0))
            $0.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints{
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints{
            
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: ComicModel? {
        didSet {
            guard let model = model else { return }
            
            iconView.kf.setImage(urlString: model.cover, placeHolder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            subTitleLabel.text = "\(model.tags?.joined(separator: " " ?? "") | \(model.author ?? ""))"
            desLabel.text = model.description
            
            if spinnerName == "更新时间" {
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒💰"
                }else if(comicDate < 3600){
                    tagString = "\(Int(comicDate / 60))分前"
                }else if(comicDate < 86400){
                    tagString = "\(Int(comicDate / 3600))小时前"
                }else if(comicDate < 31536000){
                    tagString = "\(Int(comicDate / 86400))天前"
                }else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = "\(spinnerName!) \(tagString)"
                orderView.isHidden = true
            }else{
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                }else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                }else{
                    tagString = "\(model.conTag)"
                }
                if tagString != "0"{ tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)"}
                orderView.isHidden = false
            }
        }
    }
    
    
    
    var indexPath: IndexPath? {
        didSet {
            guard let indexpath = indexPath else { return }
            if indexpath.row == 0 {
                orderView.image = UIImage.init(named: "rank_frist")
            }else if indexpath.row == 1 {
                orderView.image = UIImage.init(named: "rank_second")
            }else if indexpath.row == 2 {
                orderView.image = UIImage.init(named: "rank_third")
            }else{
                orderView.image = nil
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
