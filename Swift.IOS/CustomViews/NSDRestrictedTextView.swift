//
//  RestrictedTextView.swift
//  NeeSDev
//
//  Created by Mac Mini on 2020/1/14.
//  Copyright © 2020 Nee. All rights reserved.
//

import UIKit

typealias NSDRestrictedTextViewHandler = (NSDRestrictedTextView) -> Void

class NSDRestrictedTextView: UITextView {
    
    var changeHandler: NSDRestrictedTextViewHandler = {_ in}
    var maxHandler: NSDRestrictedTextViewHandler = {_ in}
    
    let textViewPlaceholderVerticalMargin: CGFloat = 8.0 ///< placeholder垂直方向边距
    let textViewPlaceholderHorizontalMargin: CGFloat = 6.0; ///< placeholder水平方向边距

    /// 最大限制文本长度, 默认为无穷大, 即不限制, 如果被设为 0 也同样表示不限制字符数.
    private var _maxLength: Int  = 0
    var maxLength: Int {
        set {
            _maxLength = newValue
            setMaxLengthResponse()
        }
        
        get {
            return _maxLength
        }
    }

    override var text: String! {
        didSet {
            setMaxLengthResponse()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = self.font
        }
    }
    
    /// 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
    private var _placeholder: String = ""
    var placeholder: String {
        get {
            return _placeholder
        }
        
        set {
            _placeholder = newValue
            
            placeholderLabel.text = _placeholder
        }
    }

    /// 文本颜色, 默认为 .lightGray
    private var _placeholderColor: UIColor = .lightGray
    var placeholderColor: UIColor {
        get {
            return _placeholderColor
        }
        
        set {
            _placeholderColor = newValue
            placeholderLabel.textColor = _placeholderColor
        }
    }

    var placeholderLabel: UILabel = UILabel.nsd.get(.systemFont(ofSize: 15),
                                                     color: .black,
                                                     alignment: .left)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func becomeFirstResponder() -> Bool {
        let become = super.becomeFirstResponder()
        
        if become {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(textDidChange(_:)),
                                                   name: UITextView.textDidChangeNotification,
                                                   object: nil)
        }
        return become;
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)

        return resign
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        placeholderLabel.font = font
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: textViewPlaceholderVerticalMargin))
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1,
                                         constant: textViewPlaceholderHorizontalMargin))
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel,
                                         attribute: .width,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: 1,
                                         constant: -textViewPlaceholderHorizontalMargin * 2))
        
        addConstraint(NSLayoutConstraint(item: placeholderLabel,
                                         attribute: .height,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: self,
                                         attribute: .height,
                                         multiplier: 1,
                                         constant: -textViewPlaceholderVerticalMargin * 2))
        
    }

}

extension NSDRestrictedTextView {
    
    func setTextDidChangeHandler(_ handler: @escaping NSDRestrictedTextViewHandler) {
        changeHandler = handler
    }
    
    func setTextLengthDidMaxHandler(_ handler: @escaping NSDRestrictedTextViewHandler) {
        maxHandler = handler
    }
}

private extension NSDRestrictedTextView {
    @objc func textDidChange(_ notification: Notification) {
        if (notification.object as? NSDRestrictedTextView) != self {
            return
        }
        
        placeholderLabel.isHidden = text.count > 0
        
        if text.count == 1 {
            if text == " " {
                text = ""
            }
        }
        
        if text.count > 0 {
            if String(text.prefix(text.count - 1)) == "\n" {
                text = String(text.suffix(from: text.startIndex))
                resignFirstResponder()
            }
        }
        
        if _maxLength != 0 && text.count > 0 {
            if markedTextRange == nil && text.count > _maxLength {
                maxHandler(self)
                text = String(text.prefix(_maxLength))
                undoManager?.removeAllActions()
            }
        }
        
        changeHandler(self)
    }
    
    func setMaxLengthResponse() {
        placeholderLabel.isHidden = self.text.count > 0
        // 手动模拟触发通知
        let notification = Notification(name: UITextView.textDidChangeNotification, object: self)
        textDidChange(notification)
    }
}
