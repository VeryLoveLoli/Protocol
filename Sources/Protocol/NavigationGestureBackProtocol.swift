//
//  NavigationGestureBackProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

/**
 导航手势返回协议
 
 使用：
 ```swift
 class NavVC: UINavigationController, UINavigationControllerDelegate, NavigationGestureBackProtocol {
     
     /// 手势协议
     var gestureRecognizerDelegate: UIGestureRecognizerDelegate?
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         gestureRecognizerDelegate = interactivePopGestureRecognizer?.delegate
         delegate = self
     }
     
     override func pushViewController(_ viewController: UIViewController, animated: Bool) {
 
         isGestureBack = false
         
         super.pushViewController(viewController, animated: animated)
     }
     
     // MARK: - UINavigationControllerDelegate
     
     func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
         
         isGestureBack = viewControllers.count > 1
     }
 }
 ```
 
 */
public protocol NavigationGestureBackProtocol {
    
    /// 手势识别器协议
    var gestureRecognizerDelegate: UIGestureRecognizerDelegate? { get set }
    /// 是否支持手势返回
    var isGestureBack: Bool { get set }
}

/**
 导航手势返回协议实现
 */
public extension NavigationGestureBackProtocol where Self : UINavigationController {
    
    /// 是否支持手势返回
    var isGestureBack: Bool {
        
        get {
            
            return interactivePopGestureRecognizer?.delegate == nil
        }
        
        set {
            
            interactivePopGestureRecognizer?.delegate = newValue ? nil : gestureRecognizerDelegate
        }
    }
}

/**
 滑动视图支持手势返回
 */
extension UIScrollView: UIGestureRecognizerDelegate {
    
    /// 手势返回信息（可以在`deinit`时清除对应的信息）
    public static var gestureBackInfo: [String: Bool] = [:]
    /// 手势返回偏移量
    public static var gestureBackOffset = CGPoint(x: 20, y: 20)
    
    /// 是否手势返回
    open var isGestureBack: Bool {
        
        get {
            
            Self.gestureBackInfo[String(format: "%p", self)] ?? false
        }
        
        set {
            
            Self.gestureBackInfo[String(format: "%p", self)] = newValue
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /**
     手势是否传递到下一层
     */
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return isGestureBack && gestureRecognizer.location(in: window).x <= UIScrollView.gestureBackOffset.x
    }
}
