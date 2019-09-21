//
//  NSDButton.swift
//  NSDSwiftExample
//
//  Created by NWDeveloperon 2019/6/11.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit
import TangramKit

class NSDButton: UIView {
    
    let rootLayout = TGRelativeLayout()
    let backgroundImageView = UIImageView()
    let contentLayout: TGLinearLayout

    let imageView = UIImageView()
    let textLabel = UILabel()
    let subTextLabel = UILabel()
    
    private var state: UIControl.State = .normal
    
    private var subTextColor: UIColor?

    private var normalImage: UIImage?
    private var normalTextColor: UIColor = .white
    private var normalBackgroundImage: UIImage?
    private var normalBackgroundColor: UIColor = .clear
    
    private var highlightedImage: UIImage?
    private var highlightedTextColor: UIColor?
    private var highlightedBackgroundImage: UIImage?
    private var highlightedBackgroundColor: UIColor?
    
    private var disabledImage: UIImage?
    private var disabledTextColor: UIColor?
    private var disabledBackgroundImage: UIImage?
    private var disabledBackgroundColor: UIColor?
    
    private var selectedImage: UIImage?
    private var selectedTextColor: UIColor?
    private var selectedBackgroundImage: UIImage?
    private var selectedBackgroundColor: UIColor?
    
    var touchUpInsideBlock: (NSDButton)->Void = {_ in }
    var touchCancelBlock: (NSDButton)->Void = {_ in }
    var touchDownBlock: (NSDButton)->Void = {_ in }
    
    private weak  var touchDownTarget:NSObjectProtocol! = nil
    private weak  var touchUpInsideTarget:NSObjectProtocol! = nil
    private weak  var touchCancelTarget:NSObjectProtocol! = nil
    private var touchDownAction:Selector! = nil
    private var touchUpInsideAction:Selector! = nil
    private var touchCancelAction:Selector! = nil
    
    private var _isSelected: Bool = false
    public var isSelected: Bool {
        get {
            return _isSelected
        }
        
        set {
            _isSelected = newValue
            
            if newValue {
                setState(to: .selected)
            }
            else {
                setState(to: .normal)
            }
        }
    }
    
    private var _isDisabled: Bool = false
    public var isDisabled: Bool {
        get {
            return _isDisabled
        }
        
        set {
            _isDisabled = newValue
            
            if newValue {
                setState(to: .disabled)
            }
            else if isSelected {
                setState(to: .selected)
            }
            else {
                setState(to: .normal)
            }
        }
    }
    
    init(_ orientation: TGOrientation) {
        contentLayout = TGLinearLayout(orientation)
        super.init(frame: .zero)
        
        self.uiMaker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

//MARK:- =========================== state ===========================
extension NSDButton {
    func setState(to state: UIControl.State) {
        //不可用状态时，无法修改
        if self.state == .disabled {
            return
        }
        
        switch state {
        case .normal:
            setState(with: normalImage, textColor: normalTextColor,backgroundImage:normalBackgroundImage, backgroundColor: normalBackgroundColor)
        case .highlighted:
            setState(with: highlightedImage, textColor: highlightedTextColor,backgroundImage:highlightedBackgroundImage, backgroundColor: highlightedBackgroundColor)
        case .selected:
            setState(with: selectedImage, textColor: selectedTextColor,backgroundImage:selectedBackgroundImage, backgroundColor: selectedBackgroundColor)
        case .disabled:
            setState(with: disabledImage, textColor: disabledTextColor,backgroundImage:disabledBackgroundImage, backgroundColor: disabledBackgroundColor)
            
        default:
            break
        }
        
        self.state = state
    }
    
    private func setState(with image: UIImage?, textColor: UIColor?,backgroundImage: UIImage?, backgroundColor: UIColor?) {
        if let image = image {
            imageView.image = image
            imageView.sizeToFit()
        }
        
        if let textColor = textColor {
            textLabel.textColor = textColor
            subTextLabel.textColor = textColor
        }
        
        if let subTextColor = subTextColor {
            subTextLabel.textColor = subTextColor
        }
        
        backgroundImageView.image = backgroundImage

        contentLayout.backgroundColor = backgroundColor
    }
    
    public func setNomalState(imageName: String? = nil, textColor: UIColor? = nil ,backgroundImageName: String? = nil, backgroundColor: UIColor? = nil) {
        
        if let imageName = imageName {
            normalImage = UIImage(named: imageName)
        }
        
        if let backgroundImageName = backgroundImageName {
            normalBackgroundImage = UIImage(named: backgroundImageName)
        }
        
        normalTextColor = textColor ?? .black
        
        normalBackgroundColor = backgroundColor ?? .clear
        setState(to: state)
    }
    
    public func setHighlightedState(imageName: String? = nil, textColor: UIColor? = nil, backgroundImageName: String? = nil , backgroundColor: UIColor? = nil) {
        
        if let imageName = imageName {
            highlightedImage = UIImage(named: imageName)
        }
        
        if let backgroundImageName = backgroundImageName {
            highlightedBackgroundImage = UIImage(named: backgroundImageName)
        }
        
        highlightedTextColor = textColor
        
        highlightedBackgroundColor = backgroundColor
        setState(to: state)
    }
    
    public func setSelectedState(imageName: String? = nil, textColor: UIColor? = nil,backgroundImageName: String? = nil , backgroundColor: UIColor? = nil) {
        if let imageName = imageName {
            selectedImage = UIImage(named: imageName)
        }
        if let backgroundImageName = backgroundImageName {
            selectedBackgroundImage = UIImage(named: backgroundImageName)
        }
        selectedTextColor = textColor
        selectedBackgroundColor = backgroundColor
        setState(to: state)
    }
    
    public func setDisabledState(imageName: String? = nil, textColor: UIColor? = nil,backgroundImageName: String? = nil , backgroundColor: UIColor? = nil) {
        if let imageName = imageName {
            disabledImage = UIImage(named: imageName)
        }
        if let backgroundImageName = backgroundImageName {
            disabledBackgroundImage = UIImage(named: backgroundImageName)
        }
        disabledTextColor = textColor
        disabledBackgroundColor = backgroundColor
        setState(to: state)
    }
    
    public func setStaticBackgroudImage(_ imageName :String) {
        normalBackgroundImage = UIImage(named: imageName)
        highlightedBackgroundImage = UIImage(named: imageName)
        selectedBackgroundImage = UIImage(named: imageName)
        disabledBackgroundImage = UIImage(named: imageName)
    }
    
    public func addTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControl.Event)
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
    func setText(with text:String, font:UIFont) {
        textLabel.text = text
        textLabel.font = font
        textLabel.sizeToFit()
    }
    
    func setText(with text:String, font:UIFont, color:UIColor) {
        textLabel.text = text
        textLabel.font = font
        textLabel.textColor = color
        textLabel.sizeToFit()
        
        normalTextColor = color
    }
    
    func setText(with text:String) {
        textLabel.text = text
        textLabel.sizeToFit()
    }
    
    func setTextFont(with font:UIFont) {
        textLabel.font = font
        textLabel.sizeToFit()
    }
    
    func setTextColor(with color:UIColor) {
        textLabel.textColor = color
        
        normalTextColor = color
    }
    
    func setSubText(with text:String, font:UIFont) {
        subTextLabel.text = text
        subTextLabel.font = font
        subTextLabel.sizeToFit()
    }
    
    func setSubText(with text:String, font:UIFont, color:UIColor) {
        subTextLabel.text = text
        subTextLabel.font = font
        subTextLabel.textColor = color
        subTextLabel.sizeToFit()
        
        subTextColor = color
    }
    
    func setSubText(with text:String) {
        subTextLabel.text = text
        subTextLabel.sizeToFit()
    }
    
    func setSubTextFont(with font:UIFont) {
        subTextLabel.font = font
        subTextLabel.sizeToFit()
    }
    
    func setSubTextColor(with color:UIColor) {
        textLabel.textColor = color
        
        subTextColor = color
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

        setState(to: .highlighted)
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
                setState(to: .normal)
            }
            else {
                setState(to: .highlighted)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if state == .disabled {
            return;
        }
        
        if state != .normal {
            setState(to: .normal)
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
