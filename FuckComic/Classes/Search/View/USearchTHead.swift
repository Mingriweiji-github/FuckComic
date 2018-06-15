//
//  USearchTHead.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/13.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

typealias USearchTHeadModreActionClosure = ()->Void

//protocol USearchTHeadDelegate: Class {
//    func searchTHead(_ searchTHeader: USearchHead, moreAction button: UIButton)
//}
protocol USearchTHeadDelegate: class {
    func searchTHead(_ searchTHead: USearchHead, moreAction button: UIButton)
}

class USearchHead: UBaseTableHeaderFooterView {
    
    weak var delegate: USearchTHeadDelegate?
    
    private var moreActionClosure: USearchTHeadModreActionClosure?
    
    lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.gray
        return lb
    }()
    lazy var moreButton: UIButton = {
        let mb = UIButton()
        mb.setTitleColor(UIColor.lightGray, for: .normal)
        mb.addTarget(self, action: #selector(moreAction(button:)), for: .touchUpInside)
        return mb
    }()
    
    @objc private func moreAction(button: UIButton) {
        delegate?.searchTHead(self, moreAction: button)
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: @escaping USearchTHeadModreActionClosure) {
        moreActionClosure = closure
    }
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        let line = UIView().then{ $0.backgroundColor = UIColor.background }
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
}
