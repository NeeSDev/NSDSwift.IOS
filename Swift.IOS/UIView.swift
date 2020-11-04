//
//  UIView.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit
import ReactiveCocoa
import AlamofireImage

extension UIView: NeeSDevExtended {}
extension NeeSDevExtension where ExtendedType: UIView {
    public func setBoundsStyle(cornerRadius:  CGFloat, borderWidth:  CGFloat, borderColor: UIColor) {
        type.layer.masksToBounds = true
        type.layer.cornerRadius = cornerRadius
        type.layer.borderColor = borderColor.cgColor
        type.layer.borderWidth = borderWidth
    }
    
    public func setCornerRadius(_ cornerRadius:  CGFloat) {
        type.layer.masksToBounds = true
        type.layer.cornerRadius = cornerRadius
    }
}

//MARK: - =========================== label ===========================
extension NeeSDevExtension where ExtendedType: UILabel {
    public static func get(_ font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = ExtendedType()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
    
    public static func get(_ text: String?, font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = ExtendedType.nsd.get(font, color:  color, alignment:  alignment)
        label.text = text
        //设置了文字才可以自动适配size，不影响后面添加自动适配
        label.sizeToFit()
        return label
    }
}

//MARK: - =========================== button ===========================
extension NeeSDevExtension where ExtendedType: UIButton {
    
    //MARK: - =========================== quick getter ===========================
    public static func getSelImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getSelBackgroundImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getSelBackgroundColor(_ backgroundColor: UIColor, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getBlockImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    public static func getBlockBackgroundImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    public static func getBlockBackgroundColor(_ backgroundColor: UIColor, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    //MARK: - =========================== quick setter ===========================
    //MARK:  ========= image setter =========
    public func setNormalImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .normal)
    }
    
    public func setSelectedImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .selected)
    }
    
    public func setHighlightImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= background image setter =========
    public func setNormalBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .normal)
    }
    
    public func setSelectedBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .selected)
    }
    
    public func setHighlightBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= title stter =========
    public func setNormalTitle(_ title: String?) {
        type.setTitle(title, for: .normal)
    }
    
    public func setNormalTitle(_ title: String?, color: UIColor) {
        type.setTitle(title, for: .normal)
        type.setTitleColor(color, for: .normal)
    }
    
    public func setNormalTitle(_ title: String?, font: UIFont, color: UIColor) {
        type.setTitle(title, for: .normal)
        type.setTitleColor(color, for: .normal)
        type.titleLabel?.font = font
    }
    
    public func setSelectedTitle(_ title: String?, color: UIColor) {
        type.setTitle(title, for: .selected)
        type.setTitleColor(color, for: .selected)
    }
    
    public func setSelectedTitle(_ title: String?) {
        type.setTitle(title, for: .selected)
    }
    
    public func setTitleColor(normal: UIColor, selected: UIColor) {
        type.setTitleColor(normal, for: .normal)
        type.setTitleColor(selected, for: .selected)
    }
}

extension NeeSDevExtension where ExtendedType: UITextField {
    public func setPlaceholderText(with text:String, font: UIFont, color: UIColor) {
        type.attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color,.font: font])
    }
}

//MARK:- =========================== UIImageView ===========================
extension NeeSDevExtension where ExtendedType: UIImageView {
    
    func setImage(urlString: String?, placeholderImageName: String) {
        
        let placeholaderImage = UIImage(named: placeholderImageName)
        //如果 空 string
        guard let imageURLString = urlString , imageURLString != "" else {
            //尝试设置默认图
            type.image = placeholaderImage
            return
        }
        
        //如果转 空 URL
        guard let imageURL = URL(string: imageURLString) else {
            type.image = placeholaderImage
            return
        }
        type.af.setImage(withURL: imageURL, placeholderImage: placeholaderImage)
    }
    
    func setImage(imageName: String?) {
        guard let imageName = imageName else {
            return
        }
        
        type.image = UIImage(named: imageName)
    }
}

//MARK:- =========================== UITableViewCell ===========================
public enum NSDCornerType {
    case all
    case top
    case bottom
    case none
};

extension NeeSDevExtension where ExtendedType: UITableViewCell {
    public func setCellCornerStyle(cornerRadius: CGFloat,color: UIColor = .white,cornerType: NSDCornerType = .all,edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        type.backgroundColor = .clear
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = CGRect(x: edgeInsets.left, y: edgeInsets.top, width: type.bounds.width - edgeInsets.left - edgeInsets.right, height: type.bounds.height - edgeInsets.top - edgeInsets.bottom )
        
        if cornerType == .all {
            pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        }
        else if cornerType == .top
        {
            //最顶端的Cell（两个向下圆弧和一条线）
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }
        else if cornerType == .bottom
        {
            //最底端的Cell（两个向上的圆弧和一条线）
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        }
        else if cornerType == .none
        {   //中间的Cell
            pathRef.addRect(bounds)
        }
        layer.path = pathRef
        layer.fillColor = color.cgColor //cell的填充颜色
        
        let bgView = UIView(frame: bounds)
        bgView.layer.insertSublayer(layer, at: 0)
        bgView.backgroundColor = .clear;
        type.backgroundView = bgView;
    }
}
