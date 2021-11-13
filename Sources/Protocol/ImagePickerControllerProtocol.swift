//
//  ImagePickerControllerProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit
import Photos

/**
 图片/视频选择控制器协议
 */
public protocol ImagePickerControllerProtocol: AnyObject {
    
    /// 图片/视频选择控制器处理
    var imagePickerControllerHandle: ImagePickerControllerHandle? { get set }
    
    /**
     相册资源
     
     - parameter    type:       资源类型 `nil`所有资源
     */
    func imagePickerControllerAsset(_ type: PHAssetMediaType?) -> PHFetchResult<PHAsset>
    
    /**
     提示拍照或选择相册
     
     - parameter    isEditing:      是否编辑照片/视频
     - parameter    isImage:        是否是照片 `false`为视频
     */
    func imagePickerControllerAlertCameraOrPhotoLibrary(_ isEditing: Bool, isImage: Bool)
    
    /**
     判断相机权限
     */
    @available(macCatalyst 14.0, *)
    func imagePickerControllerCameraPermissions() -> Bool
    
    /**
     判断相册权限
     */
    func imagePickerControllerPhotoLibraryPermissions() -> Bool
    
    /**
     提示设置权限
     
     - parameter    type:   权限类型
     */
    func imagePickerControllerAlertPermissions(_ type: UIImagePickerController.SourceType)
    
    /**
     打开相册/相机
     
     - parameter    type:           `.photoLibrary` 相册; `.camera`相机
     - parameter    isEditing:      是否编辑图片/视频
     - parameter    isImage:        是否是照片 `false`为视频
     */
    func imagePickerControllerOpen(_ type: UIImagePickerController.SourceType , isEditing: Bool, isImage: Bool)
    
    /**
     图片/视频选择控制器完成
     */
    func imagePickerControllerFinish(image: UIImage?, url: URL?)
    
    /**
     图片/视频选择控制器取消
     */
    func imagePickerControllerCancel()
}

/**
 图片/视频选择控制器协议实现
 */
public extension ImagePickerControllerProtocol where Self: UIViewController {
    
    /**
     相册资源
     
     - parameter    type:       资源类型 `nil`所有资源
     */
    func imagePickerControllerAsset(_ type: PHAssetMediaType? = .image) -> PHFetchResult<PHAsset> {
        
        /// 所有资源
        let all = PHFetchOptions()
        /// 时间排序
        all.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let mediaType = type {
            
            /// 过滤
            all.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
        }
        
        /// 获取
        let fetchResults = PHAsset.fetchAssets(with: .image, options: all)
        
        return fetchResults
    }
    
    /**
     提示拍照或选择相册
     
     - parameter    isEditing:      是否编辑照片/视频
     - parameter    isImage:        是否是照片 `false`为视频
     */
    func imagePickerControllerAlertCameraOrPhotoLibrary(_ isEditing: Bool = true, isImage: Bool = true) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        /// 适配 `iPad`
        if alert.popoverPresentationController != nil {
            
            /// 去掉标记
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: view.bounds.size.height, width: view.bounds.size.width, height: view.bounds.size.height)
        }
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        if #available(macCatalyst 14, *) {
            
            alert.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
                
                if self.imagePickerControllerCameraPermissions() {
                    
                    self.imagePickerControllerOpen(.camera, isEditing: isEditing, isImage: isImage)
                }
                else {
                    
                    self.imagePickerControllerAlertPermissions(.camera)
                }
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "选择相册", style: .default, handler: { (action) in
            
            if self.imagePickerControllerPhotoLibraryPermissions() {
                
                self.imagePickerControllerOpen(.photoLibrary, isEditing: isEditing, isImage: isImage)
            }
            else {
                
                self.imagePickerControllerAlertPermissions(.photoLibrary)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     判断相机权限
     */
    @available(macCatalyst 14.0, *)
    func imagePickerControllerCameraPermissions() -> Bool {
        
        /// 判断权限
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            let semaphore = DispatchSemaphore(value: 0)
            var isPermissions = false
            /// 请求权限
            AVCaptureDevice.requestAccess(for: .video) { (bool) in
                isPermissions = bool
                semaphore.signal()
            }
            semaphore.wait()
            return isPermissions
        case .restricted:
            return false
        case .denied:
            return false
        case .authorized:
            return true
        @unknown default:
            return false
        }
    }
    
    /**
     判断相册权限
     */
    func imagePickerControllerPhotoLibraryPermissions() -> Bool {
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            let semaphore = DispatchSemaphore(value: 0)
            var isPermissions = false
            /// 请求权限
            PHPhotoLibrary.requestAuthorization { (status) in
                isPermissions = status == .authorized
                semaphore.signal()
            }
            semaphore.wait()
            return isPermissions
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    /**
     提示设置权限
     
     - parameter    type:   权限类型
     */
    func imagePickerControllerAlertPermissions(_ type: UIImagePickerController.SourceType) {
        
        var message = ""
        
        switch type {
        case .camera:
            message = "请在设置中打开相机权限"
        case .photoLibrary:
            message = "请在设置中打开相册权限"
        default:
            message = "请在设置中打开权限"
        }
        
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "设置", style: .default, handler: { (action) in
            
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     打开相册/相机
     
     - parameter    type:           `.photoLibrary` 相册; `.camera`相机
     - parameter    isEditing:      是否编辑图片/视频
     - parameter    isImage:        是否是照片 `false`为视频
     */
    func imagePickerControllerOpen(_ type: UIImagePickerController.SourceType , isEditing: Bool, isImage: Bool) {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        if isImage {
            
            imagePickerController.mediaTypes = ["public.image"]
        }
        else {
            
            imagePickerController.mediaTypes = ["public.movie"]
        }
        
        imagePickerControllerHandle = ImagePickerControllerHandle.init()
        
        imagePickerControllerHandle?.finishPickingMediaWithInfoBlock = { [weak self] (image, url) in
            
            self?.imagePickerControllerFinish(image: image, url: url)
            self?.imagePickerControllerHandle = nil
            self?.presentedViewController?.dismiss(animated: true)
        }
        
        imagePickerControllerHandle?.cancelBlock = { [weak self] in
            
            self?.imagePickerControllerCancel()
            self?.imagePickerControllerHandle = nil
            self?.presentedViewController?.dismiss(animated: true)
        }
        
        imagePickerController.delegate = imagePickerControllerHandle
        imagePickerController.allowsEditing = isEditing
        imagePickerController.sourceType = type
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /**
     图片/视频选择控制器取消
     */
    func imagePickerControllerCancel() {
        
    }
}

/**
 图片/视频选择控制器处理
 */
open class ImagePickerControllerHandle: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 完成图片/视频选择
    open var finishPickingMediaWithInfoBlock: ((UIImage?, URL?)->Void)? = nil
    /// 取消图片/视频选择
    open var cancelBlock: (()->Void)? = nil
    
    // MARK: - UIImagePickerControllerDelegate
    
    /**
     完成
     */
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var photo: UIImage?
        var url: URL?
        
        switch info[UIImagePickerController.InfoKey.mediaType] {
            
        case let string as String:
            
            if string == "public.image" {
                
                var key = UIImagePickerController.InfoKey.originalImage
                
                if picker.allowsEditing {
                    
                    key = UIImagePickerController.InfoKey.editedImage
                }
                
                if let image = info[key] as? UIImage  {
                    
                    photo = image
                }
                
                if #available(iOS 11.0, *) {
                    
                    if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                        
                        url = imageURL
                    }
                    
                } else {
                    
                    if let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                        
                        url = referenceURL
                    }
                }
                
                finishPickingMediaWithInfoBlock?(photo, url)
                
                picker.delegate = nil
            }
            else if string == "public.movie" {
                
                if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    
                    url = mediaURL
                }
                
                var asset: PHAsset?
                
                if #available(iOS 11.0, *) {
                    
                    asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
                }
                else {
                    
                    if let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                        
                        let options = PHFetchOptions.init()
                        options.includeHiddenAssets = true
                        options.includeAllBurstAssets = true
                        
                        for kvItem in (referenceURL.query ?? "").components(separatedBy: "&") {
                            
                            let kv = kvItem.components(separatedBy: "=")
                            
                            if kv.count == 2 {
                                
                                if kv[0] == "id" {
                                    
                                    asset = PHAsset.fetchAssets(withLocalIdentifiers: [kv[1]], options: options).lastObject
                                    
                                    break
                                }
                            }
                        }
                    }
                }
                
                if let asset = asset {
                    
                    let options = PHImageRequestOptions.init()
                    options.version = .current
                    options.deliveryMode = .fastFormat
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: CGFloat(asset.pixelWidth)/UIScreen.main.scale, height: CGFloat(asset.pixelWidth)/UIScreen.main.scale), contentMode: .default, options: options) { (image, info) in
                        
                        photo = image
                        
                        self.finishPickingMediaWithInfoBlock?(photo, url)
                        
                        picker.delegate = nil
                    }
                }
                else {
                    
                    finishPickingMediaWithInfoBlock?(photo, url)
                    
                    picker.delegate = nil
                }
            }
            
        default:
            
            finishPickingMediaWithInfoBlock?(photo, url)
            
            picker.delegate = nil
        }
    }
    
    /**
     取消
     */
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        cancelBlock?()
        
        picker.delegate = nil
    }
}
