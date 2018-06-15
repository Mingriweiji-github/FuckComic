//
//  UBaseTableHeaderFooterView.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/13.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit
import Reusable

class UBaseTableHeaderFooterView: UITableViewHeaderFooterView, Reusable {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has hot been implemented")
    }
    
    open func configUI(){}
}
