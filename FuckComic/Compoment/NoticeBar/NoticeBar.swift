//
//  NoticeBar.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/8.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit

public enum UNoticeBarStyle{
    case onStatusBar
    case onNavigationBar
}

public enum UNoticeBarAnimationType {
    case top, bottom, left, right
}
extension UNoticeBarAnimationType {
    fileprivate func noticeBarViewTransform(with frame: CGRect, _ style: UNoticeBarStyle) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        
        switch (style,self) {
        case (_, .top):
            transform = CGAffineTransform(translationX: 0, y: -frame.height)
        case (_, .bottom):
            transform = CGAffineTransform(translationX: 0, y: -frame.height)
        case (_, .left):
            transform = CGAffineTransform(translationX: -frame.width, y: 0)
        case (_, .right):
            transform = CGAffineTransform(translationX: frame.width, y: 0)
        }
        
        return transform
    }
}
extension UNoticeBarStyle {
    
    fileprivate func noticeBarProperties() ->  UNoticeBarProperties{
        let screenWitd = UIScreen.main.bounds.width
        
        var properties: UNoticeBarProperties
        switch self {
        case .onNavigationBar:
            properties = UNoticeBarProperties(shadowOffsetX: 3,
                                              fontSizeScaleFactor: 0.55,
                                              textFont: UIFont.systemFont(ofSize: 18),
                                              viewFrame: CGRect(origin: CGPoint.zero,
                                                                size: CGSize(width: screenWitd, height: 44 + UIApplication.shared.statusBarFrame.height)))
        case .onStatusBar:
            properties = UNoticeBarProperties(shadowOffsetX: 2,
                                              fontSizeScaleFactor: 0.75,
                                              textFont: UIFont.systemFont(ofSize: 13),
                                              viewFrame: CGRect(origin: CGPoint.zero,
                                                                size: CGSize(width: screenWitd,
                                                                             height: UIApplication.shared.statusBarFrame.height)))
        }
        return properties
    }
    
    fileprivate func noticBarOrignY (superViewHeight: CGFloat, _ height: CGFloat) -> CGFloat{
        var origintY: CGFloat = 0
        switch self {
        case .onNavigationBar:
            origintY = UIApplication.shared.statusBarFrame.height + (superViewHeight - UIApplication.shared.statusBarFrame.height - height) * 0.5
        case .onStatusBar:
            origintY = (superViewHeight - height) * 0.5
        }
        return origintY
    }
    
    fileprivate var beginWindowLevel: UIWindowLevel {
        switch self {
        case .onStatusBar:
            return UIWindowLevelStatusBar + 1
        default:
            return UIWindowLevelNormal
        }
    }
    
    fileprivate var endWindowLevel: UIWindowLevel {
        return UIWindowLevelNormal
    }
}



fileprivate struct UNoticeBarProperties {
    init() {}
    var shadowOffsetX: CGFloat = 0
    var fontSizeScaleFactor: CGFloat = 0
    var textFont = UIFont()
    var viewFrame = CGRect.zero
    
    init(shadowOffsetX : CGFloat, fontSizeScaleFactor: CGFloat, textFont: UIFont , viewFrame: CGRect) {
        self.shadowOffsetX = shadowOffsetX
        self.fontSizeScaleFactor = fontSizeScaleFactor
        self.textFont = textFont
        self.viewFrame = viewFrame
    }
}

public struct UNoticeBarConfig {
    public init(){}

    public var title: String?
    public var image: UIImage? = nil
    public var margin: CGFloat = 10.0
    public var textColor: UIColor = UIColor.black
    public var backgroundColor = UIColor.white
    public var animationType = UNoticeBarAnimationType.top
    public var barStyle = UNoticeBarStyle.onNavigationBar
    
    public init(title: String? = nil,
                image: UIImage? = nil,
                textColor: UIColor = UIColor.white,
                backgroundColor: UIColor = UIColor.orange,
                barStyle: UNoticeBarStyle = .onNavigationBar,
                animationType: UNoticeBarAnimationType = .top) {
        
        self.title = title
        self.image = image
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.barStyle = barStyle
        self.animationType = animationType
    }

}
//open class UnoticeBar: UIView {
//    private var config = UnoticeBar
//}





































