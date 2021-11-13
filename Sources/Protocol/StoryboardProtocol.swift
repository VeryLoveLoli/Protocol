//
//  StoryboardProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

/**
 故事板协议
 
 故事板初始化视图控制器，自动转换对应的类
 */
public protocol StoryboardProtocol {
    
    /**
     故事板初始化视图控制器，调用 storyboard(_ name: String,bundle:bundle?)
     */
    static func storyboard() -> Self
    
    /**
     故事板初始化视图控制器，调用 storyboard(name: String,bundle:bundle?, identifier: String)
     
     - parameter    name:           故事板名称
     - parameter    bundle:         Bundle包
     */
    static func storyboard(_ name: String, bundle: Bundle?) -> Self
    
    /**
     故事板初始化视图控制器
     
     - parameter    name:           故事板名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     视图控制器ID
     */
    static func storyboard(_ name: String, bundle: Bundle?, identifier: String) -> Self
    
    /**
     默认设置
     */
    static func defaultSetting(_ vc: UIViewController)
}

/**
 故事板协议实现
 */
public extension StoryboardProtocol {
    
    /**
     故事板初始化视图控制器，调用 storyboard(_ name: String,bundle:bundle?)
     */
    static func storyboard() -> Self {
        
        return storyboard("\(Self.self)")
    }
    
    /**
     故事板初始化视图控制器，调用 storyboard(name: String,bundle:bundle?, identifier: String)
     
     - parameter    name:           故事板名称
     - parameter    bundle:         Bundle包
     */
    static func storyboard(_ name: String, bundle: Bundle? = nil) -> Self {
        
        return storyboard(name, bundle: bundle, identifier: "\(Self.self)")
    }
    
    /**
     故事板初始化视图控制器
     
     - parameter    name:           故事板名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     视图控制器ID
     */
    static func storyboard(_ name: String, bundle: Bundle? = nil, identifier: String) -> Self {
        
        let vc = UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: identifier)
        defaultSetting(vc)
        return vc as! Self
    }
    
    /**
     默认设置
     */
    static func defaultSetting(_ vc: UIViewController) {
        
    }
}
