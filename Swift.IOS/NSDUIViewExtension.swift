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
public extension NeeSDevExtension where ExtendedType: UIView {
    func setBoundsStyle(cornerRadius:  CGFloat, borderWidth:  CGFloat, borderColor: UIColor) {
        type.layer.masksToBounds = true
        type.layer.cornerRadius = cornerRadius
        type.layer.borderColor = borderColor.cgColor
        type.layer.borderWidth = borderWidth
    }
    
    func setCornerRadius(_ cornerRadius:  CGFloat) {
        type.layer.masksToBounds = true
        type.layer.cornerRadius = cornerRadius
    }
}

//MARK: - =========================== label ===========================
public extension NeeSDevExtension where ExtendedType: UILabel {
    static func get(_ font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = ExtendedType()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
    
    static func get(_ text: String?, font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = ExtendedType.nsd.get(font, color:  color, alignment:  alignment)
        label.text = text
        //设置了文字才可以自动适配size，不影响后面添加自动适配
        label.sizeToFit()
        return label
    }
}

//MARK: - =========================== button ===========================
public extension NeeSDevExtension where ExtendedType: UIButton {
    
    //MARK: - =========================== quick getter ===========================
    static func getSelImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    static func getSelBackgroundImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    static func getSelBackgroundColor(_ backgroundColor: UIColor, target:  Any?, action:  Selector) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    static func getBlockImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    static func getBlockBackgroundImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    static func getBlockBackgroundColor(_ backgroundColor: UIColor, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = ExtendedType.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    //MARK: - =========================== quick setter ===========================
    //MARK:  ========= image setter =========
    func setNormalImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .normal)
    }
    
    func setSelectedImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .selected)
    }
    
    func setHighlightImage(_ imageName: String) {
        type.setImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= background image setter =========
    func setNormalBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .normal)
    }
    
    func setSelectedBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .selected)
    }
    
    func setHighlightBackgroundImage(_ imageName: String) {
        type.setBackgroundImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= title stter =========
    func setNormalTitle(_ title: String?) {
        type.setTitle(title, for: .normal)
    }
    
    func setNormalTitle(_ title: String?, color: UIColor) {
        type.setTitle(title, for: .normal)
        type.setTitleColor(color, for: .normal)
    }
    
    func setNormalTitle(_ title: String?, font: UIFont, color: UIColor) {
        type.setTitle(title, for: .normal)
        type.setTitleColor(color, for: .normal)
        type.titleLabel?.font = font
    }
    
    func setSelectedTitle(_ title: String?, color: UIColor) {
        type.setTitle(title, for: .selected)
        type.setTitleColor(color, for: .selected)
    }
    
    func setSelectedTitle(_ title: String?) {
        type.setTitle(title, for: .selected)
    }
    
    func setTitleColor(normal: UIColor, selected: UIColor) {
        type.setTitleColor(normal, for: .normal)
        type.setTitleColor(selected, for: .selected)
    }
}

public extension NeeSDevExtension where ExtendedType: UITextField {
    func setPlaceholderText(with text:String, font: UIFont, color: UIColor) {
        type.attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color,.font: font])
    }
}

//MARK:- =========================== UIImageView ===========================
public extension NeeSDevExtension where ExtendedType: UIImageView {
    static func get(_ imageNamed: String) -> UIImageView {
        return UIImageView(image: UIImage(named: imageNamed))
    }
    
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

public extension NeeSDevExtension where ExtendedType: UITableViewCell {
    func setCellCornerStyle(cornerRadius: CGFloat,color: UIColor = .white,cornerType: NSDCornerType = .all,edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
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
