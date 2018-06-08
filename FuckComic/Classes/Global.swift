//
//  Global.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/8.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import MJRefresh

extension UIColor {
    class var background: UIColor {
        return UIColor(red: 242, green: 242, blue: 242, alpha: 1)
    }
    class var theme: UIColor {
        return UIColor(red: 29, green: 221, blue: 43, alpha: 1)
    }
}

extension String {
    static let searchHistoryKey = "searchHistory"
    static let sexTypeKey = "sexTypeKey"
}

extension NSNotification.Name {
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
}

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC  = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentationController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}
private func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    }else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    }else{
        return vc
    }
}
//MAKR:Print
func fLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber:Int = #line)   {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):function:\(function):line:\(lineNumber)] - \(message)")
    #endif
}





































