//
//  UTabBarController.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/12.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

class UTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        //首页
        let homePageVC = UHomeViewController(titles: ["推荐","VIP"], vcs: [UBoutiqueListViewController(),UVIPListViewController()], pagestyles: .navigationBarSegment)
        
        addChildViewController(homePageVC, title: "首页", image: UIImage(named: "tab_home"), selectedImage: UIImage(named: "tab_home_S"))
        //分类
        
        let categoryVC = UCateListViewController()
        addChildViewController(categoryVC,
                               title: "分类",
                               image: UIImage(named: "tab_class"),
                               selectedImage: UIImage(named: "tab_class_S"))
        
        //书架
        let bookVC = UBookViewController(titles: ["收藏","书单","下载"], vcs: [UCollectListViewController(),UDocumentListViewController(),UDownloadListViewController()], pagestyles: .navigationBarSegment)
        
        addChildViewController(bookVC, title: "书架", image: UIImage(named: "tab_book"), selectedImage: UIImage(named: "tab_book_S"))
        
        //我的
        let mineVC = UMineViewController()
        addChildViewController(mineVC, title: "我的", image: UIImage(named: "tab_mine"), selectedImage: UIImage(named: "tab_mine_S"))
        
    }
    
    func addChildViewController(_ childController: UIViewController, title: String?, image: UIImage?, selectedImage:UIImage?) {
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
        
        addChildViewController(UNavigationController(rootViewController: childController))
    }
    
}

extension UTabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        guard let select = selectedViewController else {
            return .lightContent
        }
        return select.preferredStatusBarStyle
    }
    
}
