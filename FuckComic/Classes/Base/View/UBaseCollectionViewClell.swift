//
//  UBaseCollectionViewClee.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/13.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit
import Reusable

class UBaseCollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init (coder:) has not implement")
    }
    open func configUI() {}
}
