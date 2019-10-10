//
//  NSDButton.swift
//  NSDSwiftExample
//
//  Created by NWDeveloperon 2019/6/11.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit
import TangramKit

/// 自定义按钮
/// 使用block的方式，根据回调state参数，开放式进行各状态下的操作
class NSDButton: UIView {
    
    /// root图层，包含背景图以及内容两个图层
    let rootLayout = TGRelativeLayout()
    
    /// 内容图层
    let contentLayout: TGLinearLayout
    
    /// 背景图
    let backgroundImageView = UIImageView()
    
    /// image
    let imageView = UIImageView()
    
    /// title标签
    private let textLabel = UILabel()
    
    /// 子标签
    private let subTextLabel = UILabel()
    
    /// 是否选中
    private var _isSelected: Bool = false
    /// 是否选中
    public var isSelected: Bool {
        get {
            return _isSelected
        }
        
        set {
            _isSelected = newValue
            if isDisabled {
                return
            }else if _isSelected {
                state = .selected
            }
        }
    }
    
    /// 是否禁用
    private var _isDisabled: Bool = false
    /// 是否禁用
    public var isDisabled: Bool {
        get {
            return _isDisabled
        }
        
        set {
            _isDisabled = newValue
            if _isDisabled {
                state = .disabled
            }else if _isSelected {
                state = .selected
            }
        }
    }
    
    /// 当前状态
    private var _state: UIControl.State = .normal
    /// 当前状态
    public var state: UIControl.State {
        get {
            return _state
        }
        
        set {
           _state = newValue
            stateListener(_state)
        }
    }
    
    /// 状态监听回调
    private var stateListener: (UIControl.State) -> Void = {_ in }
    
    /// 点击抬起在范围内的回调
    private var touchUpInsideBlock: (NSDButton)->Void = {_ in }
    
    /// 点击取消的回调
    private var touchCancelBlock: (NSDButton)->Void = {_ in }
    
    /// 点击开始的回调
    private var touchDownBlock: (NSDButton)->Void = {_ in }
    
    /// 点击抬起在范围内的Target
    private weak var touchUpInsideTarget:NSObjectProtocol! = nil
    /// 点击抬起在范围内的Action
    private var touchUpInsideAction:Selector! = nil
    
    /// 点击取消的Target
    private weak var touchCancelTarget:NSObjectProtocol! = nil
    /// 点击取消的Action
    private var touchCancelAction:Selector! = nil
    
    /// 点击开始的Target
    private weak var touchDownTarget:NSObjectProtocol! = nil
    /// 点击开始的Action
    private var touchDownAction:Selector! = nil
    
    /// 初始化
    /// - Parameter orientation: 布局方向
    init(_ orientation: TGOrientation) {
        contentLayout = TGLinearLayout(orientation)
        super.init(frame: .zero)
        
        self.uiMaker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 布局
    func uiMaker() {
        rootLayout.tg_margin(0)
        addSubview(rootLayout)
        
        backgroundImageView.tg_margin(0)
        rootLayout.addSubview(backgroundImageView)
        
        contentLayout.tg_margin(0)
        contentLayout.tg_gravity = .center
        rootLayout.addSubview(contentLayout)

        contentLayout.addSubview(imageView)
        contentLayout.addSubview(textLabel)
        contentLayout.addSubview(subTextLabel)
    }
}

//MARK:- =========================== 添加响应事件 ===========================
extension NSDButton {
    
    /// 添加状态监听block
    /// - Parameter stateListener: 回调方法
    func addStateListener(_ stateListener: @escaping (UIControl.State) -> Void) {
        self.stateListener = stateListener
    }
    
    /// 添加block回调
    /// - Parameter controlEvents: 事件
    /// - Parameter block: 回调
    func addBlock(for controlEvents: UIControl.Event, block: @escaping (NSDButton)->Void) {
        switch controlEvents {
        case UIControl.Event.touchDown:
            touchDownBlock = block
            break
        case UIControl.Event.touchUpInside:
            touchUpInsideBlock = block
            break
        case UIControl.Event.touchCancel:
            touchCancelBlock = block
            break
        default:
            return
        }
    }
    
    /// 添加target响应selector
    /// - Parameter target: 响应对象
    /// - Parameter action: 响应方法
    /// - Parameter controlEvents: 事件
    func addTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControl.Event)
    {
        //just only support these events
        switch controlEvents {
        case UIControl.Event.touchDown:
            touchDownTarget = target
            touchDownAction = action
            break
        case UIControl.Event.touchUpInside:
            touchUpInsideTarget = target
            touchUpInsideAction = action
            break
        case UIControl.Event.touchCancel:
            touchCancelTarget = target
            touchCancelAction = action
            break
        default:
            return
        }
        
    }
}
 
extension NSDButton {
    /// 设置title
    var text: String {
        get {
            return textLabel.text ?? ""
        }
        
        set {
            textLabel.text = newValue
            textLabel.sizeToFit()
        }
    }
    
    /// 设置title字体
    var font: UIFont {
        get {
            return textLabel.font
        }
        
        set {
            textLabel.font = newValue
            textLabel.sizeToFit()
        }
    }
    
    /// 设置title字体颜色
    var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        
        set {
            textLabel.textColor = newValue
        }
    }
    
    /// 设置sub title
    var subText: String {
        get {
            return subTextLabel.text ?? ""
        }
        
        set {
            subTextLabel.text = newValue
            subTextLabel.sizeToFit()
        }
    }
    
    /// 设置sub title字体
    var subFont: UIFont {
        get {
            return subTextLabel.font
        }
        
        set {
            subTextLabel.font = newValue
            subTextLabel.sizeToFit()
        }
    }
    
    /// 设置sub title字体颜色
    var subTextColor: UIColor {
        get {
            return subTextLabel.textColor
        }
        
        set {
            subTextLabel.textColor = newValue
        }
    }
}


extension NSDButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if state == .disabled {
            return;
        }
        
        touchDownBlock(self)
        _ = touchDownTarget?.perform(touchDownAction, with: self)

        state = .highlighted
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if state == .disabled {
            return;
        }
        
        if state == .highlighted {
            
            guard let touch = touches.first else {
                return
            }
            
            if point(inside: touch.location(in: self), with: event) {
                state = .normal
            }
            else {
                state = .highlighted
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if state == .disabled {
            return;
        }
        
        if state != .normal {
            state = .normal
        }
        
        guard let touch = touches.first else {
            return
        }
        
        if point(inside: touch.location(in: self), with: event) {
            touchUpInsideBlock(self)
            _ = touchUpInsideTarget?.perform(touchUpInsideAction, with: self)
        }
        else {
            touchCancelBlock(self)
            _ = touchCancelTarget?.perform(touchCancelAction, with: self)
        }
    }
}
