//
//  UIAlertController.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit

extension UIAlertController: NeeSDevExtended {}
public extension NeeSDevExtension where ExtendedType: UIAlertController {
    //MARK: - =========================== quick shower ===========================
    static func showAlert<kindofViewController: UIViewController>(_ title: String?,
                                                                        message: String?,
                                                                        target: kindofViewController?,
                                                                        confirmText: String? = "确定",
                                                                        confirmBlock: @escaping () -> Void = {}) {
        let alert = ExtendedType.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmText, style: .default, handler: { (alertAction) in
            confirmBlock()
        }))
        
        if let target = target {
            target.present(alert, animated: true)
        }
    }
    
    static func showAlert<kindofViewController: UIViewController>(_ title: String?,
                                                                        message: String?,
                                                                        target: kindofViewController?,
                                                                        cancel: String? = "取消",
                                                                        confirmText: String? = "确定",
                                                                        animations: @escaping () -> Void) {
        let alert = ExtendedType.init(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancel, style: .cancel))
        
        alert.addAction(UIAlertAction(title: confirmText, style: .default) { (alertAction) in
            animations()
        })
        
        if let target = target {
            target.present(alert, animated: true)
        }
    }
}
