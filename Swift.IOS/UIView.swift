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

extension NSD where Base: UIView {
    public func setBoundsStyle(cornerRadius:  CGFloat, borderWidth:  CGFloat, borderColor: UIColor) {
        baseObj.layer.masksToBounds = true
        baseObj.layer.cornerRadius = cornerRadius
        baseObj.layer.borderColor = borderColor.cgColor
        baseObj.layer.borderWidth = borderWidth
    }
    
    public func setCornerRadius(_ cornerRadius:  CGFloat) {
        baseObj.layer.masksToBounds = true
        baseObj.layer.cornerRadius = cornerRadius
    }
}

//MARK: - =========================== label ===========================
extension NSD where Base: UILabel {
    public static func get(_ font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = Base()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
    
    public static func get(_ text: String?, font:  UIFont, color:  UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = Base.nsd.get(font, color:  color, alignment:  alignment)
        label.text = text
        //设置了文字才可以自动适配size，不影响后面添加自动适配
        label.sizeToFit()
        return label
    }
}

//MARK: - =========================== button ===========================
extension NSD where Base: UIButton {
    
    //MARK: - =========================== quick getter ===========================
    public static func getSelImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getSelBackgroundImage(_ imageName: String, target:  Any?, action:  Selector) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getSelBackgroundColor(_ backgroundColor: UIColor, target:  Any?, action:  Selector) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.addTarget(target, action:  action, for: .touchUpInside)
        return btn
    }
    
    public static func getBlockImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.nsd.setNormalImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    public static func getBlockBackgroundImage(_ imageName: String, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.nsd.setNormalBackgroundImage(imageName)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    public static func getBlockBackgroundColor(_ backgroundColor: UIColor, action:  @escaping (UIButton) -> Void) -> UIButton {
        let btn = Base.init(type: .custom)
        btn.backgroundColor = backgroundColor
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            action(button)
        }
        return btn
    }
    
    //MARK: - =========================== quick setter ===========================
    //MARK:  ========= image setter =========
    public func setNormalImage(_ imageName: String) {
        baseObj.setImage(UIImage(named:  imageName), for: .normal)
    }
    
    public func setSelectedImage(_ imageName: String) {
        baseObj.setImage(UIImage(named:  imageName), for: .selected)
    }
    
    public func setHighlightImage(_ imageName: String) {
        baseObj.setImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= background image setter =========
    public func setNormalBackgroundImage(_ imageName: String) {
        baseObj.setBackgroundImage(UIImage(named:  imageName), for: .normal)
    }
    
    public func setSelectedBackgroundImage(_ imageName: String) {
        baseObj.setBackgroundImage(UIImage(named:  imageName), for: .selected)
    }
    
    public func setHighlightBackgroundImage(_ imageName: String) {
        baseObj.setBackgroundImage(UIImage(named:  imageName), for: .highlighted)
    }
    
    //MARK:  ========= title stter =========
    public func setNormalTitle(_ title: String?) {
        baseObj.setTitle(title, for: .normal)
    }
    
    public func setNormalTitle(_ title: String?, color: UIColor) {
        baseObj.setTitle(title, for: .normal)
        baseObj.setTitleColor(color, for: .normal)
    }
    
    public func setNormalTitle(_ title: String?, font: UIFont, color: UIColor) {
        baseObj.setTitle(title, for: .normal)
        baseObj.setTitleColor(color, for: .normal)
        baseObj.titleLabel?.font = font
    }
    
    public func setSelectedTitle(_ title: String?, color: UIColor) {
        baseObj.setTitle(title, for: .selected)
        baseObj.setTitleColor(color, for: .selected)
    }
    
    public func setSelectedTitle(_ title: String?) {
        baseObj.setTitle(title, for: .selected)
    }
    
    public func setTitleColor(normal: UIColor, selected: UIColor) {
        baseObj.setTitleColor(normal, for: .normal)
        baseObj.setTitleColor(selected, for: .selected)
    }
}

extension NSD where Base: UITextField {
    public func setPlaceholderText(with text:String, font: UIFont, color: UIColor) {
        baseObj.attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color,.font: font])
    }
}

extension NSD where Base: UITableView {
    public static func getPlain(target: UITableViewDataSource & UITableViewDelegate) -> UITableView {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = target
        view.dataSource = target
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }
}

//MARK:- =========================== UIImageView ===========================
extension NSD where Base: UIImageView {
    
    func setImage(urlString: String?, placeholderImageName: String) {
        
        let placeholaderImage = UIImage(named: placeholderImageName)
        //如果 空 string
        guard let imageURLString = urlString , imageURLString != "" else {
            //尝试设置默认图
            baseObj.image = placeholaderImage
            return
        }
        
        //如果转 空 URL
        guard let imageURL = URL(string: imageURLString) else {
            baseObj.image = placeholaderImage
            return
        }
        baseObj.af_setImage(withURL: imageURL, placeholderImage: placeholaderImage)
    }
    
    func setImage(imageName: String?) {
        guard let imageName = imageName else {
            return
        }
        
        baseObj.image = UIImage(named: imageName)
    }
}

//MARK:- =========================== UITableViewCell ===========================
public enum NSDCornerType {
    case all
    case top
    case bottom
    case none
};

extension NSD where Base: UITableViewCell {
    public func setCellCornerStyle(cornerRadius: CGFloat,color: UIColor = .white,cornerType: NSDCornerType = .all,edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        baseObj.backgroundColor = .clear
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = CGRect(x: edgeInsets.left, y: edgeInsets.top, width: baseObj.bounds.width - edgeInsets.left - edgeInsets.right, height: baseObj.bounds.height - edgeInsets.top - edgeInsets.bottom )
        
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
        baseObj.backgroundView = bgView;
    }
}
