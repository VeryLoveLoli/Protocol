//
//  NavigationBarProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

/**
 导航栏协议
 */
public protocol NavigationBarProtocol {
    
    /// 是否导航栏滑动偏移小于`0`才显示（`iOS13`才有，默认`true`）
    var isNavigationBarScrollShow: Bool { get set }
    
    /// 是否导航栏紧凑时使用系统默认显示
    var isNavigationBarCompactShow: Bool { get set }
    
    /// 导航栏背景颜色
    var navigationBarBackgroundColor: UIColor? { get set }
    
    /// 导航栏背景图片
    var navigationBarBackgroundImage: UIImage? { get set }
    
    /// 导航栏阴影颜色
    var navigationBarShadowColor: UIColor? { get set }
    
    /// 导航栏阴影图片
    var navigationBarShadowImage: UIImage? { get set }
    
    /// 导航栏标题属性
    var navigationBarTitleTextAttributes: [NSAttributedString.Key : Any] { get set }
    
    /// 导航栏大标题属性
    var navigationBarLargeTitleTextAttributes: [NSAttributedString.Key : Any] { get set }
    
    /// 是否使用导航栏大标题
    var isNavigationBarLargeTitle: Bool { get set }
    
    /// 是否导航栏半透明
    var isNavigationBarTranslucent: Bool { get set }
    
    /**
     导航栏更新（设置图片、颜色、文字属性后需要更新）
     */
    func navigationBarUpdate()
}

/**
 导航栏协议实现
 */
public extension NavigationBarProtocol where Self : UINavigationController {
    
    /// 是否导航栏滑动偏移小于`0`才显示（`iOS13`才有，默认`true`）
    var isNavigationBarScrollShow: Bool {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.scrollEdgeAppearance == nil
            }
            else {
                
                return false
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                /// 不设置则默认阴影、背景图片/颜色透明，`scroll`偏移大于`0`则阴影、背景图片/颜色透明大于`0` ，偏移值大概`10`就`alpha=1`
                /// 如果导航仅需要背景颜色，设置`navigationController`背景颜色，这个可以保留阴影上滑显示
                navigationBar.scrollEdgeAppearance = newValue ? nil : navigationBar.standardAppearance
                
                if #available(iOS 15.0, *) {
                    navigationBar.compactScrollEdgeAppearance = newValue ? nil : navigationBar.standardAppearance
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    /// 是否导航栏紧凑时使用系统默认显示
    var isNavigationBarCompactShow: Bool {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.compactAppearance == nil
            }
            else {
                
                return false
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                /// 如果导航仅需要背景颜色，设置`navigationController`背景颜色，这个可以保留阴影上滑显示
                navigationBar.compactAppearance = newValue ? nil : navigationBar.standardAppearance
            }
        }
    }
    
    /// 导航栏背景颜色
    var navigationBarBackgroundColor: UIColor? {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.backgroundColor
            }
            else {
                
                return navigationBar.backgroundColor
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.backgroundColor = newValue
            }
            else {
                
                navigationBar.backgroundColor = newValue
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 导航栏背景图片
    var navigationBarBackgroundImage: UIImage? {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.backgroundImage
            }
            else {
                
                return navigationBar.backgroundImage(for: .default)
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.backgroundImage = newValue
            }
            else {
                
                navigationBar.setBackgroundImage(newValue, for: .default)
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 导航栏阴影颜色
    var navigationBarShadowColor: UIColor? {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.shadowColor
            }
            else {
                
                return nil
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.shadowColor = newValue
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 导航栏阴影图片
    var navigationBarShadowImage: UIImage? {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.shadowImage
            }
            else {
                
                return navigationBar.shadowImage
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.shadowImage = newValue
            }
            else {
                
                navigationBar.shadowImage = newValue
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 导航栏标题属性
    var navigationBarTitleTextAttributes: [NSAttributedString.Key : Any] {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.titleTextAttributes
            }
            else {
                
                return navigationBar.titleTextAttributes ?? [:]
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.titleTextAttributes = newValue
            }
            else {
                
                navigationBar.titleTextAttributes = newValue
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 导航栏大标题属性
    var navigationBarLargeTitleTextAttributes: [NSAttributedString.Key : Any] {
        
        get {
            
            if #available(iOS 13, *) {
                
                return navigationBar.standardAppearance.largeTitleTextAttributes
            }
            else {
                
                return navigationBar.largeTitleTextAttributes ?? [:]
            }
        }
        
        set {
            
            if #available(iOS 13, *) {
                
                navigationBar.standardAppearance.largeTitleTextAttributes = newValue
            }
            else {
                
                navigationBar.largeTitleTextAttributes = newValue
            }
            
            navigationBarUpdate()
        }
    }
    
    /// 是否使用导航栏大标题
    var isNavigationBarLargeTitle: Bool {
        
        get {
            
            navigationBar.prefersLargeTitles
        }
        
        set {
            
            navigationBar.prefersLargeTitles = newValue
        }
    }
    
    /// 是否导航栏半透明
    var isNavigationBarTranslucent: Bool {
        
        get {
            
            navigationBar.isTranslucent
        }
        
        set {
            
            navigationBar.isTranslucent = newValue
        }
    }
    
    /**
     导航栏更新（设置图片、颜色、文字属性后需要更新）
     */
    func navigationBarUpdate() {
        
        if !isNavigationBarScrollShow {
            
            isNavigationBarScrollShow = false
        }
        
        if !isNavigationBarCompactShow {
            
            isNavigationBarCompactShow = false
        }
    }
}
