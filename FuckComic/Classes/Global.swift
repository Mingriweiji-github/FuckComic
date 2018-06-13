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

//MARK:Kingfisher
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeHolder: Placeholder? =
        UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""), placeholder: placeHolder,
                        options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControlState,
                         placeHolder:UIImage? = UIImage(named: "normal_placeholder_h")) ->
        RetrieveImageTask {
            return setImage(with: URL(string: urlString ?? ""), for: state, placeholder: placeHolder,
                            options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
    }
}
//MARK:SnapKit
extension ConstraintView {
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }else{
            return self.snp
        }
    }
}

extension UICollectionView {

    func reloadData(animation: Bool = true){
        if animation {
            reloadData()
        }else {
            UIView.performWithoutAnimation {
                reloadData()
            }
        }
    }
}

//MARK: swizzledMethod
extension NSObject {
    static func swizzleMethod(_ cls: AnyClass, originalSelector: Selector,
                              swizzleSelector: Selector){
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        let didAddMethod = class_addMethod(cls,
                                           originalSelector,
                                           method_getImplementation(swizzleMethod!),
                                            method_getTypeEncoding(swizzleMethod!))
       
        if didAddMethod {
            class_replaceMethod(cls,
                                swizzleSelector,
                                method_getImplementation(originalMethod!),
                                method_getTypeEncoding(originalMethod!))
        }else {
            method_exchangeImplementations(originalMethod!, swizzleMethod!)
        }
    }
}

extension UIApplication {
    private static let u_initialize: Void = {
        UINavigationController.u_initialize
        if #available(iOS 11.0, *) {
            UINavigationBar.u_initialize
        }
    }()
    
    open override var next: UIResponder? {
        UIApplication.u_initialize
        return super.next
    }
}




























