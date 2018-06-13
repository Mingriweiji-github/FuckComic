//
//  UHomeViewController.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/12.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class UHomeViewController: UPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .plain, target: self, action: #selector(selecAction))
    }
    
    @objc private func selecAction() {
        navigationController?.pushViewController(, animated: <#T##Bool#>)
    }
}
