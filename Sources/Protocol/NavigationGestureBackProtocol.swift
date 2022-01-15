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
    
    /// 手势传递到下一层信息（可以在`deinit`时清除对应的信息）
    public static var gestureToNextInfo: [String: Bool] = [:]
    
    /// 是否手势传递到下一层
    open var isGestureToNext: Bool {
        
        get {
            
            Self.gestureToNextInfo[String(format: "%p", self)] ?? false
        }
        
        set {
            
            Self.gestureToNextInfo[String(format: "%p", self)] = newValue
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /**
     手势是否传递到下一层
     */
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return isGestureToNext
    }
}
