//
//  UMineHead.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/25.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class UMineHead: UIView {

    private lazy var bgView: UIImageView = {
        
        let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(sexTypeDidChange), name: .USexTypeDidChange, object: nil)
    }
    
    @objc func sexTypeDidChange() {
        let sexType = UserDefaults.standard.integer(forKey: String.sexTypeKey)
        if sexType == 1 {
            bgView.image = UIImage(named: "mine_bg_for_boy")
        }else {
            bgView.image = UIImage(named: "mine_bg_for_girl")
        }
        
    }
    
}
