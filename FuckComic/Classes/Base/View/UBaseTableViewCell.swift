//
//  UBaseTableViewCell.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/15.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit
import Reusable

class UbaseTableViewCell: UITableViewCell, Reusable {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder error")
    }
    open func configUI(){}
}
