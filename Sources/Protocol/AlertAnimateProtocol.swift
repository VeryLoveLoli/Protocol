//
//  AlertAnimateProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

/**
 提示动画协议
 */
public protocol AlertAnimateProtocol {
    
    /// 提示动画类型
    var alertAnimateType: AlertAnimateType { get set }
    /// 提示动画透明度
    var alertAnimateAlpha: CGFloat { get set }
    /// 提示动画时间
    var alertAnimateDuration: TimeInterval { get set }
    
    /// 提示动画透明层视图
    var alertAnimateAlphaView: UIView { get set }
    /// 提示动画视图
    var alertAnimateView: UIView { get set }
    
    /**
     显示
     
     - parameter    animated:      是否动画
     - parameter    completion:    动画完成
     */
    func show(_ animated: Bool, completion: (() -> Swift.Void)?)
    
    /**
     显示
     */
    func show()
    
    /**
     隐藏
     
     - parameter    animated:      是否动画
     - parameter    completion:    动画完成
     */
    func hide(_ animated: Bool, completion: (() -> Swift.Void)?)
    
    /**
     隐藏
     */
    func hide()
}

/**
 提示动画协议实现
 */
public extension AlertAnimateProtocol {
    
    /**
     显示
     
     - parameter    animated:      是否动画
     - parameter    completion:    动画完成
     */
    func show(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if animated {
            
            UIView.animate(withDuration: alertAnimateDuration, animations: {
                
                self.show()
                
            }) { (bool) in
                
                completion?()
            }
        }
        else {
            
            show()
            
            completion?()
        }
    }
    
    /**
     显示
     */
    func show() {
        
        alertAnimateAlphaView.alpha = alertAnimateAlpha
        
        switch alertAnimateType {
            
        case .scale:
            
            alertAnimateView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            
        case .top:
            
            alertAnimateView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            
        case .bottom:
            
            alertAnimateView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    /**
     隐藏
     
     - parameter    animated:      是否动画
     - parameter    completion:    动画完成
     */
    func hide(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if animated {
            
            UIView.animate(withDuration: alertAnimateDuration, animations: {
                
                self.hide()
                
            }) { (bool) in
                
                completion?()
            }
        }
        else {
            
            hide()
            
            completion?()
        }
    }
    
    /**
     隐藏
     */
    func hide() {
        
        alertAnimateAlphaView.alpha = 0
        
        switch alertAnimateType {
            
        case .scale:
            
            alertAnimateView.transform = CGAffineTransform.init(scaleX: 0.000001, y: 0.000001)
            
        case .top:
            
            alertAnimateView.transform = CGAffineTransform.init(translationX: 0, y: -alertAnimateView.frame.size.height)
            
        case .bottom:
            
            alertAnimateView.transform = CGAffineTransform.init(translationX: 0, y: alertAnimateView.frame.size.height)
        }
    }
}

/**
 提示动画类型
 */
public enum AlertAnimateType {
    
    /// 从中间由小到大弹出，反动画收起
    case scale
    /// 从顶部弹出，反动画收起
    case top
    /// 从底部弹出，反动画收起
    case bottom
}
