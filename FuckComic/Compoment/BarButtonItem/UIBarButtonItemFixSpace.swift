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
            
        }
    }
    
    
}
