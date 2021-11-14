//
//  ScriptMessageHandlerProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/14.
//

import Foundation
import WebKit

/**
 脚本消息处理协议
 */
public protocol ScriptMessageHandlerProtocol: WKScriptMessageHandler {
    
    /// 网页视图
    var webView: WKWebView? { get set }
    
    /**
     添加响应
     
     脚本发消息`window.webkit.messageHandlers.<方法名称>.postMessage(<消息内容>)`
     <方法名称> 字符串
     <消息内容> 支持 `NSNumber, NSString, NSDate, NSArray, NSDictionary, NSNull`
     
     脚本发消息后在`func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)`接收消息
     
     - parameter    names:      方法名称列表
     */
    func scriptMessageHandlerAddResponse(_ names: String...)
    
    /**
     添加脚本
     
     - parameter    source:             脚本源码
     - parameter    injectionTime:      注入时间
     - parameter    forMainFrameOnly:   是否仅主框架
     */
    func scriptMessageHandlerAddScript(_ source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool)
    
    /**
     调用脚本
     
     - parameter    function:           方法
     - parameter    content:            参数内容
     - parameter    completionHandler       回调
     */
    func scriptMessageHandlerCall(_ function: String, content: String?, completionHandler: ((Any?, Error?) -> Void)?)
}

/**
 脚本消息处理协议实现
 */
public extension ScriptMessageHandlerProtocol {
    
    /**
     添加响应
     
     脚本发消息`window.webkit.messageHandlers.<方法名称>.postMessage(<消息内容>)`
     <方法名称> 字符串
     <消息内容> 支持 `NSNumber, NSString, NSDate, NSArray, NSDictionary, NSNull`
     
     脚本发消息后在`func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)`接收消息
     
     - parameter    names:      方法名称列表
     */
    func scriptMessageHandlerAddResponse(_ names: String...) {
        
        let handler = ScriptMessageHandler(self)
        
        for name in names {
            
            webView?.configuration.userContentController.add(handler, name: name)
        }
    }
    
    /**
     添加脚本
     
     - parameter    source:             脚本源码
     - parameter    injectionTime:      注入时间
     - parameter    forMainFrameOnly:   是否仅主框架
     */
    func scriptMessageHandlerAddScript(_ source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool) {
        
        let userScript = WKUserScript(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        
        webView?.configuration.userContentController.addUserScript(userScript)
    }
    
    /**
     调用脚本
     
     - parameter    function:           方法
     - parameter    content:            参数内容
     - parameter    completionHandler       回调
     */
    func scriptMessageHandlerCall(_ function: String, content: String? = nil, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        
        var javaScript = function
        
        javaScript += "("
        
        if let param = content {
            
            javaScript += "\(param)"
        }
        
        javaScript += ")"
        
        webView?.evaluateJavaScript(javaScript, completionHandler: completionHandler)
    }
}


/**
 脚本消息处理
 */
open class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    // MARK: - Parameter
    
    /// 协议对象
    open weak var delegate: WKScriptMessageHandler?
    
    // MARK: - init
    
    /**
     初始化
     */
    public init(_ delegate: WKScriptMessageHandler) {
        
        self.delegate = delegate
    }
    
    // MARK: - WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
