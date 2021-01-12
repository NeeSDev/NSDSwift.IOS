//
//  UIAlertController.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit

extension UIAlertController: NeeSDevExtended {}
extension NeeSDevExtension where ExtendedType: UIAlertController {
    //MARK: - =========================== quick shower ===========================
    public static func showAlert<kindofViewController: UIViewController>(_ title: String?,
                                                                        message: String?,
                                                                        target: kindofViewController?,
                                                                        confirm: String? = "确定",
                                                                        confirmBlock: @escaping () -> Void = {}) {
        ExtendedType.nsd.showAlert(title, message: message, target: target, cancel: nil, confirm: confirm) { (isOK) in
            if isOK {
                confirmBlock()
            }
        }
    }
    
    public static func showAlert<kindofViewController: UIViewController>(_ title: String?,
                                                                        message: String?,
                                                                        target: kindofViewController?,
                                                                        cancel: String? = "取消",
                                                                        confirm: String? = "确定",
                                                                        confirmBlock: @escaping () -> Void) {
        ExtendedType.nsd.showAlert(title, message: message, target: target, cancel: cancel, confirm: confirm) { (isOK) in
            if isOK {
                confirmBlock()
            }
        }
    }
    
    public static func showAlert<kindofViewController: UIViewController>(_ title: String?,
                                                                        message: String?,
                                                                        target: kindofViewController?,
                                                                        cancel: String? = "取消",
                                                                        confirm: String? = "确定",
                                                                        handler: @escaping (Bool) -> Void) {
        let alert = ExtendedType.init(title: title, message: message, preferredStyle: .alert)
        
        if let cancel = cancel {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel) { (alertAction) in
                handler(false)
            })
        }
        
        if let confirm = confirm {
            alert.addAction(UIAlertAction(title: confirm, style: .default) { (alertAction) in
                handler(true)
            })
        }
        
        if let target = target {
            target.present(alert, animated: true)
        }
    }
}
