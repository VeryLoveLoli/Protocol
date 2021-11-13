//
//  NavigationItemProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit
import WebKit

/**
 导航按钮位置
 */
public enum NavigationItemLocation {
    /// 左边
    case left
    /// 右边
    case right
}

/**
 导航按钮协议
 */
public protocol NavigationItemProtocol {
    
    /**
     导航按钮
     
     - parameter    image:          图片
     - parameter    title:          文字
     - parameter    titleColor:     文字颜色
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     
     - returns  `UIButton`
     */
    func navItemButton(_ image: UIImage?, title: String?, titleColor: UIColor?, target: AnyObject?, action: Selector?) -> UIButton
    
    /**
     添加导航按钮
     
     - parameter    image:          图片
     - parameter    title:          文字
     - parameter    titleColor:     文字颜色
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     - parameter    location:       位置
     */
    func addNavItem(_ image: UIImage?, title: String?, titleColor: UIColor?, target: AnyObject?, action: Selector?, location: NavigationItemLocation)
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIView, target: AnyObject?, action: Selector?, location: NavigationItemLocation)
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIButton, location: NavigationItemLocation)
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIBarButtonItem, location: NavigationItemLocation)
    
    /**
     导航按钮返回事件
     
     - parameter    webView:    网页视图
     */
    func navItemBackEvent(_ webView: WKWebView?)
}

/**
 导航按钮协议实现
 */
public extension NavigationItemProtocol where Self : UIViewController {
    
    /**
     导航按钮
     
     - parameter    image:          图片
     - parameter    title:          文字
     - parameter    titleColor:     文字颜色
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     
     - returns  `UIButton`
     */
    func navItemButton(_ image: UIImage? = nil, title: String? = nil, titleColor: UIColor? = nil, target: AnyObject? = nil, action: Selector? = nil) -> UIButton {
        
        let button = UIButton.init(type: .custom)
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if let icon = image {
            
            button.setImage(icon, for: .normal)
            width += icon.size.width
            height += icon.size.height
        }
        
        if let t = title {
            
            let font = UIFont.systemFont(ofSize: 16)
            button.titleLabel?.font = font
            button.setTitle(title, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
            let rect = t.boundingRect(with: CGSize(width: 10000, height: 44), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ], context: nil)
            width += rect.size.width + 1
            if height < rect.size.height {
                
                height = rect.size.height
            }
        }
        
        button.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        if let t = target, let a = action {
            
            button.addTarget(t, action: a, for: .touchUpInside)
        }
        
        return button
    }
    
    /**
     添加导航按钮
     
     - parameter    image:          图片
     - parameter    title:          文字
     - parameter    titleColor:     文字颜色
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     - parameter    location:       位置
     */
    func addNavItem(_ image: UIImage? = nil, title: String? = nil, titleColor: UIColor?, target: AnyObject? = nil, action: Selector? = nil, location: NavigationItemLocation = .right) {
        
        let button = navItemButton(image, title: title, titleColor: titleColor, target: target, action: action)
        
        addNavItem(button, location: location)
    }
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    target:         目标对象
     - parameter    action:         对象方法
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIView, target: AnyObject? = nil, action: Selector? = nil, location: NavigationItemLocation = .right) {
        
        let barItem = UIBarButtonItem(customView: item)
        barItem.target = target
        barItem.action = action
        
        addNavItem(barItem, location: location)
    }
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIButton, location: NavigationItemLocation = .right) {
        
        addNavItem(UIBarButtonItem(customView: item), location: location)
    }
    
    /**
     添加导航按钮
     
     - parameter    item:           按钮
     - parameter    location:       位置
     */
    func addNavItem(_ item: UIBarButtonItem, location: NavigationItemLocation = .right) {
                
        switch location {
        case .left:
            if navigationItem.leftBarButtonItems == nil {
                navigationItem.leftBarButtonItems = [item]
            }
            else {
                navigationItem.leftBarButtonItems?.append(item)
            }
        case .right:
            if navigationItem.rightBarButtonItems == nil {
                navigationItem.rightBarButtonItems = [item]
            }
            else {
                navigationItem.rightBarButtonItems?.append(item)
            }
        }
    }
    
    /**
     导航按钮返回事件
     
     - parameter    webView:    网页视图
     */
    func navItemBackEvent(_ webView: WKWebView? = nil) {
        
        if webView?.canGoBack ?? false {
            
            webView?.goBack()
        }
        else if let nav = navigationController {
            
            if nav.viewControllers.count > 1 {
                
                nav.popViewController(animated: true)
            }
            else if nav.presentingViewController != nil {
                
                dismiss(animated: true)
            }
        }
        else if presentingViewController != nil {
            
            dismiss(animated: true)
        }
    }
}
