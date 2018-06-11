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
    var shadowOffsetY: CGFloat = 0
    var fontSizeScaleFactor: CGFloat = 0
    var textFont = UIFont()
    var viewFrame = CGRect.zero
    
    init(shadowOffsetX : CGFloat, fontSizeScaleFactor: CGFloat, textFont: UIFont , viewFrame: CGRect) {
        self.shadowOffsetY = shadowOffsetX
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
open class UnoticeBar: UIView {
    private var config = UNoticeBarConfig()
    private var _titleLabel: UILabel?
    private var _imageView: UIImageView?
    
    open var titleLabel: UILabel? {
        return _titleLabel
    }
    open var imageView: UIImageView? {
        return _imageView
    }
    public func show(duration: TimeInterval, completed: ((_ finished: Bool) -> Void)? = nil) {
        self.show(duration: duration, willShow: {
            [weak self] in
            guard let strongSelf = self else {return}
            let currentWindowLevel = strongSelf.config.barStyle.beginWindowLevel
            UIApplication.shared.keyWindow?.windowLevel = currentWindowLevel
            
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            completed?(finished)
            if finished{
                let currentWindowLevel = strongSelf.config.barStyle.endWindowLevel
                UIApplication.shared.keyWindow?.windowLevel = currentWindowLevel
            }
        }
    }
    public init(config: UNoticeBarConfig) {
        super.init(frame: config.barStyle.noticeBarProperties().viewFrame)
        self.backgroundColor = config.backgroundColor
        self.config = config
        
        self.layer.shadowOffset = CGSize(width: 0, height: config.barStyle.noticeBarProperties().shadowOffsetY)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.44
        
        configSubViews()
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    private func configSubViews() {
        _titleLabel = UILabel()
        _titleLabel?.text = config.title
        _titleLabel?.textColor = config.textColor
        _titleLabel?.minimumScaleFactor = config.barStyle.noticeBarProperties().fontSizeScaleFactor
        _titleLabel?.adjustsFontSizeToFitWidth = true
        _titleLabel?.font = config.barStyle.noticeBarProperties().textFont
        
        var titleLabelOriginX: CGFloat = 0
        var titleLabelOriginY: CGFloat = 0
        var titleLabelHeight:CGFloat = 0
        var titleLabelWidth:CGFloat = 0
        
        if let image = config.image,config.barStyle != .onStatusBar {
            _imageView = UIImageView(image: image)
            _imageView?.contentMode = .scaleAspectFill
            addSubview(_imageView!)
            
            let imageViewWidth: CGFloat = 25
            let imageViewOriginX = config.margin + 10
            let imageViewOriginY = config.barStyle.noticBarOrignY(superViewHeight: frame.height, imageViewWidth)
            _imageView?.frame = CGRect(origin: CGPoint(x: imageViewOriginX, y: imageViewOriginY),
                                       size: CGSize(width: imageViewWidth, height: imageViewWidth))
            titleLabelOriginX = _imageView!.frame.maxX + config.margin
            titleLabelOriginY = _imageView!.frame.origin.y
            titleLabelHeight = _imageView!.frame.size.height
            titleLabelWidth = UIScreen.main.bounds.width - titleLabelOriginX - config.margin
            _titleLabel?.textAlignment = .left
        }else {
            _titleLabel?.textAlignment = .center
            
            titleLabelHeight = 25
            titleLabelWidth = UIScreen.main.bounds.width - 2 * config.margin
            titleLabelOriginY = config.barStyle.noticBarOrignY(superViewHeight: frame.height, titleLabelHeight)
            titleLabelOriginX = config.margin
        }
        _titleLabel?.frame = CGRect(x: titleLabelOriginX, y: titleLabelOriginY, width: titleLabelWidth, height: titleLabelHeight)
    }
    private func show(duration: TimeInterval, willShow: () -> Void, completed: ((_ finished: Bool) -> Void)?) {
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for view in subviews {
                if view.isKind(of: UnoticeBar.self) {
                    view.removeFromSuperview()
                }
            }
        }
        willShow()
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.transform = config.animationType.noticeBarViewTransform(with: frame, self.config.barStyle)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                UIView.animate(withDuration: 0.4,
                               animations: {
                                self.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.removeFromSuperview()
                })
            })
        }
    }
}





































