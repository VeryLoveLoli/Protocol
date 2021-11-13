//
//  ModalPresentProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

/**
 模态展示协议
 */
public protocol ModalPresentProtocol {
    
    /**
     模态展示
     
     - parameter    vc:                     视图控制器
     - parameter    animated:               是否动画
     - parameter    capturesStatusBar:      是否捕获状态栏
     - parameter    transitionStyle:        过度样式
     - parameter    presentationStyle:      展示样式
     - parameter    completion:             完成回调
     */
    func modalPresent(_ vc: UIViewController,
                      animated flag: Bool,
                      capturesStatusBar: Bool,
                      transitionStyle: UIModalTransitionStyle,
                      presentationStyle:  UIModalPresentationStyle,
                      completion: (() -> Void)?)
}

/**
 模态展示协议实现
 */
public extension ModalPresentProtocol where Self : UIViewController {
    
    /**
     模态展示
     
     - parameter    vc:                     视图控制器
     - parameter    animated:               是否动画
     - parameter    capturesStatusBar:      是否捕获状态栏
     - parameter    transitionStyle:        过度样式
     - parameter    presentationStyle:      展示样式
     - parameter    completion:             完成回调
     */
    func modalPresent(_ vc: UIViewController,
                      animated flag: Bool,
                      capturesStatusBar: Bool = true,
                      transitionStyle: UIModalTransitionStyle = .crossDissolve,
                      presentationStyle:  UIModalPresentationStyle = .overFullScreen,
                      completion: (() -> Void)? = nil) {
        
        vc.modalPresentationCapturesStatusBarAppearance = capturesStatusBar
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = presentationStyle
        
        present(vc, animated: flag, completion: completion)
    }
}
