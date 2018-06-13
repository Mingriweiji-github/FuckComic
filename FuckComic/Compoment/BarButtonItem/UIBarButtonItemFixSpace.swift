//
//  UIBarButtonItemFixSpace.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/11.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import Foundation
import UIKit

public var u_defaultFixSpace: CGFloat = 0
public var u_disableFixSpace: Bool = false

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var tempDisableFixSpace: Void?
        static var tempBehavor: Void?
    }
    
    static let u_initialize: Void = {
        DispatchQueue.once {
           swizzleMethod(UINavigationController.self,
                         originalSelector: #selector(UINavigationController.viewDidLoad),
                         swizzleSelector: #selector(UINavigationController.u_viewDidLoad))
            swizzleMethod(UINavigationController.self,
                          originalSelector: #selector(UINavigationController.viewWillAppear(_:)),
                          swizzleSelector: #selector(UINavigationController.u_viewWillAppear))
            swizzleMethod(UINavigationController.self,
                          originalSelector: #selector(UINavigationController.viewWillDisappear(_:)),
                          swizzleSelector: #selector(UINavigationController.u_viewWillDisappear))
        }
    }()
    
    
    
    private var tempDisableFixSpace: Bool {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.tempDisableFixSpace) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempDisableFixSpace, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @available(iOS 11.0,*)
    private var tempBehavor: UIScrollViewContentInsetAdjustmentBehavior {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tempBehavor) as? UIScrollViewContentInsetAdjustmentBehavior ?? .automatic
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempBehavor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private func disableFixSpace(_ disable: Bool,with temp: Bool) {
        if self is UIImagePickerController {
            if disable{
                if temp {tempDisableFixSpace = u_disableFixSpace}
                u_disableFixSpace = true
                if #available(iOS 11.0, *) {
                    tempBehavor = UIScrollView.appearance().contentInsetAdjustmentBehavior
                    UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                }
            } else {
                u_disableFixSpace = tempDisableFixSpace
                if #available(iOS 11.0, *) {
                    UIScrollView.appearance().contentInsetAdjustmentBehavior = tempBehavor
                }
            }
        }
    }
    
    @objc private func u_viewDidLoad() {
        disableFixSpace(true, with: true)
        u_viewDidLoad()
    }
    @objc private func u_viewWillAppear() {
        disableFixSpace(true, with: false)
        u_viewWillAppear()
    }
    @objc private func u_viewWillDisappear() {
        disableFixSpace(false, with: true)
        u_viewWillDisappear()
    }
}

@available(iOS 11.0, *)
extension UINavigationBar {
    
    static let u_initialize: Void = {
        DispatchQueue.once {
            swizzleMethod(UINavigationBar.self,
                          originalSelector: #selector(UINavigationBar.layoutSubviews),
                          swizzleSelector: #selector(UINavigationBar.u_layoutSubViews))
        }
    }()
    
    @objc func u_layoutSubViews() {
        u_layoutSubViews()
        
        if !u_disableFixSpace {
            layoutMargins = .zero
            let space = u_defaultFixSpace
            for view in subviews {
                if NSStringFromClass(view.classForCoder).contains("ContentView") {
                    view.layoutMargins = UIEdgeInsetsMake(0, space, 0, space)
                }
            }
            
        }
    }
}


extension UINavigationItem {
    private enum BarButtonItem: String {
        case left = "_leftBarButtonItem"
        case right = "_rightBarButtonItem"
    }
    
    open override func setValue(_ value: Any?, forKey key: String) {
        if #available(iOS 11.0, *) {
            super.setValue(value, forKey: key)
        } else {
            if !u_disableFixSpace && (key == BarButtonItem.left.rawValue || key == BarButtonItem.right.rawValue) {
                guard let item = value as? UIBarButtonItem else {
                    super.setValue(value, forKey: key)
                    return
                }
                let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                            target: nil,
                                            action: nil)
                
                space.width = u_defaultFixSpace - 16
                
                if key == BarButtonItem.left.rawValue {
                    leftBarButtonItems = [space, item]
                }else {
                    rightBarButtonItems = [space, item]
                }
            } else {
                super.setValue(value, forKey: key)
            }
        }
    }
}































