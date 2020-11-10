//
//  NSDSegementView.swift
//  NeeSDev
//
//  Created by Mac Mini on 2019/6/13.
//  Copyright © 2019 Nee. All rights reserved.
//

import UIKit
import TangramKit

//MARK:- =========================== segement view ===========================
public class NSDSegementView: TGRelativeLayout {
    private var contentLayout = TGRelativeLayout()
    /// title字符串 数组
    
    private var titles: [String] = []
    private var subTitles: [String] = []
    
    /// 每个标题固定宽度
    private var titleWidth: CGFloat = -1

    /// 每个标题根据自己的文字长度自适应宽度
    private var titleWidthOffset: CGFloat = -1

    /// 按钮存储 数组
    private var buttons: [NSDButton] = []
//    private var subButtons: [UIButton] = []

    /// 正常的颜色
    private var normalColor: UIColor = .white
    
    /// 选中的颜色
    private var selectedColor: UIColor = .white
    
    /// 当前选中的index
    private var _selectedIndex: Int = -1
    public var selectedIndex: Int {
        return _selectedIndex
    }
    
    /// 绑定关系的scrollView
    private var scrollView: UIScrollView?
    
    /// 切换完成后回调
    private var selectBlock: (Int)->Void = {_ in }
    
    private var selectFlagView = UIView()
    private var selectFlagWidth:CGFloat = -1

    public init(titles: [String], titleWidthOffset: CGFloat, subTitles: [String] = []) {
        super.init(frame: .zero)
        self.titleWidthOffset = titleWidthOffset
        
        if 0 < subTitles.count, titles.count == subTitles.count {
            self.subTitles = subTitles
        }
        
        if 0 < titles.count {
            self.titles = titles
            uiMaker()
        }
    }
    
    public init(titles: [String], titleWidth: CGFloat, subTitles: [String] = []) {
        super.init(frame: .zero)
        self.titleWidth = titleWidth
        
        if 0 < subTitles.count, titles.count == subTitles.count {
            self.subTitles = subTitles
        }
        
        if 0 < titles.count {
            self.titles = titles
            uiMaker()
        }
    }
    
    public func update(titles: [String], subTitles: [String] = []) {
        self.subTitles = subTitles
        self.titles = titles
        resetTitles()
    }
    
    public init(titles: [String], subTitles: [String] = []) {
        super.init(frame: .zero)
        
        if 0 < subTitles.count, titles.count == subTitles.count {
            self.subTitles = subTitles
        }
        
        if 0 < titles.count {
            self.titles = titles
            uiMaker()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension NSDSegementView {
    func uiMaker() {
        let rootScrollView = UIScrollView()
        rootScrollView.showsHorizontalScrollIndicator = false
        rootScrollView.tg_margin(0)
        addSubview(rootScrollView)
        
        contentLayout.tg_height.equal(.fill)
        if contentLayout.superview == nil {
            rootScrollView.addSubview(contentLayout)
        }
        
        contentLayout.tg_removeAllSubviews()
        buttons.removeAll()
        _selectedIndex = -1
        selectFlagView.isHidden = true

        let titlesLayout = TGLinearLayout(.horz)
        titlesLayout.tg_height.equal(.fill)
        contentLayout.addSubview(titlesLayout)
        
        if titleWidthOffset < 0 && titleWidth < 0 {
            contentLayout.tg_width.equal(.fill)
            titlesLayout.tg_width.equal(.fill)
        }
        else {
            contentLayout.tg_width.equal(.wrap)
            titlesLayout.tg_width.equal(.wrap)
        }
        

        for (index,title) in titles.enumerated() {
            let button = NSDButton(.vert)
            button.addTarget(self, action: #selector(segementClick), for: .touchUpInside)
            button.setText(with: title, font: .systemFont(ofSize: 15))
            if subTitles.count > 0 {
                button.rootLayout.tg_vspace = 3
                button.setSubText(with: subTitles[index],font: .systemFont(ofSize: 13))
            }
            
            if titleWidthOffset < 0 , titleWidth < 0 {
                button.tg_width.equal(titlesLayout.tg_width).multiply(1.0/CGFloat(titles.count))
            }
            else if titleWidth > 0 {
                button.tg_width.equal(titleWidth)
            }
            else {
                if titleWidthOffset >= 1.0 {
                    button.tg_width.equal(button.tg_width).add(titleWidthOffset)
                }
                else {
                    button.tg_width.equal(button.tg_width).multiply(1.0 + titleWidthOffset)
                }
            }
            
            button.tg_vertMargin(0)
            if index == 0 {
                button.tg_left.equal(0)
            }
            else {
                button.tg_left.equal(buttons[index - 1].tg_right)
            }
            
            button.tag = index
            titlesLayout.addSubview(button)
            buttons.append(button)
        }
        
        if 0 < titles.count {
            setSelected(index: 0, isBlock: false)
        }
        
        selectFlagView.tg_bottom.equal(contentLayout)
        contentLayout.addSubview(selectFlagView)
    }
    
    func resetTitles() {
        for (index,button) in buttons.enumerated() {
            button.setText(with: titles[index])
            button.setSubText(with: subTitles[index])
        }
    }
    
    func updateSelectedFlagStatus() {
        
        if selectFlagWidth > 0 {
            selectFlagView.tg_width.equal(selectFlagWidth)
        }
        else if titleWidthOffset < 0 , titleWidth < 0 {
            selectFlagView.tg_width.equal(buttons[selectedIndex].tg_width).multiply(1.0/2.0).max(30)
        }
        else if titleWidth > 0 {
            selectFlagView.tg_width.equal(buttons[selectedIndex].tg_width).multiply(1.0/2.0)
        }
        else {
            if titleWidthOffset >= 1.0 {
                selectFlagView.tg_width.equal(buttons[selectedIndex].tg_width).add(-titleWidthOffset)
            }
            else {
                selectFlagView.tg_width.equal(buttons[selectedIndex].tg_width).multiply(1.0/(1 + titleWidthOffset))
            }
        }
        
        
        selectFlagView.tg_centerX.equal(buttons[selectedIndex].tg_centerX)
        contentLayout.tg_layoutAnimationWithDuration(0.3)
    }
}


public extension NSDSegementView {
    func setTitles(titles: [String], subTitles: [String] = []) {
        self.titles = titles
        self.subTitles = subTitles
        uiMaker()
    }
    
    func setSelectStyle(color: UIColor,height: CGFloat = 3,width: CGFloat = -1) {
        if height == 0 {
            selectFlagView.isHidden = true
            return
        }
        selectFlagView.isHidden = false
        selectFlagView.tg_height.equal(height)
        selectFlagView.backgroundColor = color
        selectFlagWidth = width
        
        if selectedIndex != -1  {
            updateSelectedFlagStatus()
        }
    }
    
    /// 按钮切换响应
    ///
    /// - Parameter button: 按钮
    @objc func segementClick(button: NSDButton) {
        setSelected(index: button.tag)
    }
    
    /// 设置title颜色
    ///
    /// - Parameters:
    ///   - normal: 正常颜色
    ///   - selected: 选中颜色
    func setTitleColor(normal: UIColor, selected: UIColor) {
        normalColor = normal
        selectedColor = selected
        
        for button in buttons {
            button.setNomalState(textColor: normal)
            button.setSelectedState(textColor: selected)
        }
    }
    
    /// 设置切换回调
    ///
    /// - Parameter block: 回调方法
    func setSelectBlock(block: @escaping (Int)->Void) {
        selectBlock = block
    }
    
    /// 设置选中index
    ///
    /// - Parameters:
    ///   - index: index
    ///   - isBlock: 是否响应回调
    func setSelected(index: Int, isBlock: Bool = true) {
        if selectedIndex == index {
            return
        }
        
        if selectedIndex != -1 {
            buttons[selectedIndex].isSelected = false
        }
        
        _selectedIndex = index
        buttons[selectedIndex].isSelected = true
        
        if !selectFlagView.isHidden {
            updateSelectedFlagStatus()
        }
        
        if let scrollView = scrollView {
            let widthValue = scrollView.frame.width
            scrollView.setContentOffset(CGPoint(x: widthValue * CGFloat(index), y: 0), animated: true)
        }
        
        if isBlock {
            selectBlock(selectedIndex)
        }
    }
    
    func setFont(_ font: UIFont, subFont: UIFont = UIFont.systemFont(ofSize: 13)) {
        for button in buttons {
            button.setTextFont(with: font)
            button.setSubTextFont(with: subFont)
        }
    }
}

extension NSDSegementView: UIScrollViewDelegate {
    
    func setRelativeScrollView(_ relativeScrollView:UIScrollView) {
        scrollView = relativeScrollView
        scrollView?.delegate = self
    }
    
    /// 检验 scroll view 的偏移量是否与 selected index 一致
    private func checkSelectedStatus() {
        guard let scrollView = scrollView  else {
            return
        }
        
        let scrollViewOffsetIndex = Int(scrollView.contentOffset.x/scrollView.frame.width);
        if (selectedIndex != scrollViewOffsetIndex) {
            setSelected(index: scrollViewOffsetIndex)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkSelectedStatus()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        checkSelectedStatus()
    }
}


//MARK:- =========================== segement scroll view ===========================

///
///使用例子
///
/// let item0 = UIView()
/// item0.backgroundColor = .red
//
/// let item1 = UIView()
/// item1.backgroundColor = .yellow
///
/// let item2 = UIView()
/// item2.backgroundColor = .blue
///
/// let view = NSDSegementScrollView(titles: ["123","234","345"], views: [item0,item1,item2])
/// view.setTitleColor(normal: HDWColor.orange, selected: .green)
/// view.setSelectStyle(.white)
/// view.tg_horzMargin(0)
/// view.tg_height.equal(.fill)
/// rootLayout.addSubview(view)

public class NSDSegementScrollView: TGLinearLayout {
    private let headerView: NSDSegementView!
    private let scrollView = UIScrollView()
    private var titles: [String] = []
    private var views: [UIView] = []
    
    /// 切换完成后回调
    private var selectBlock: (Int)->Void = {_ in }
    
    public init(titles: [String],views: [UIView],titleWidthOffset: CGFloat, subTitles: [String] = []) {
        headerView = NSDSegementView(titles: titles,titleWidthOffset: titleWidthOffset, subTitles: subTitles)
        super.init(frame: .zero, orientation: .vert)
        self.titles = titles
        self.views = views
        uiMaker()
    }
    
    public init(titles: [String],views: [UIView],titleWidth: CGFloat, subTitles: [String] = []) {
        headerView = NSDSegementView(titles: titles,titleWidth: titleWidth, subTitles: subTitles)
        super.init(frame: .zero, orientation: .vert)
        self.titles = titles
        self.views = views
        uiMaker()
    }
    
    public init(titles: [String],views: [UIView], subTitles: [String] = []) {
        headerView = NSDSegementView(titles: titles)
        super.init(frame: .zero, orientation: .vert)
        self.titles = titles
        self.views = views
        uiMaker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public var selectedIndex: Int {
        return headerView.selectedIndex
    }
    
    public func setSelected(index: Int) {
        headerView.setSelected(index: index)
    }
    
    // 数值设置左右偏移量
    public func setHeader(edgeInsets: UIEdgeInsets = UIEdgeInsets(0),height: CGFloat = 45) {
        headerView.tg_padding = edgeInsets
        headerView.tg_height.equal(height)
    }
}


extension NSDSegementScrollView {
    
    /// UI 布局
    func uiMaker() {
        headerView.tg_left.equal(0)
        headerView.tg_right.equal(0)
        headerView.tg_height.equal(45)
        addSubview(headerView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.tg_horzMargin(0)
        scrollView.tg_height.equal(.fill)
        addSubview(scrollView)
        
        let flowLayout = TGFlowLayout(.vert, arrangedCount:1)
        flowLayout.tg_pagedCount = 1
        flowLayout.tg_width.equal(.wrap)
        flowLayout.tg_height.equal(scrollView.tg_height)
        flowLayout.tg_insetsPaddingFromSafeArea = UIRectEdge(rawValue: 0)
        scrollView.addSubview(flowLayout)
        
        for item in views {
            flowLayout.addSubview(item)
        }
        
        uiLogicMaker()
    }
    
    //UI 逻辑（可分离时分离）
    func uiLogicMaker() {
        headerView.setRelativeScrollView(scrollView)

        headerView.setSelectBlock { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.selectBlock(index)
        }
    }
    
    /// 设置title文字颜色
    ///
    /// - Parameters:
    ///   - normal: 正常颜色
    ///   - selected: 选中颜色
    public func setTitleColor(normal: UIColor, selected: UIColor) {
        headerView.setTitleColor(normal: normal, selected: selected)
    }
    
    /// 设置title文字的字体
    ///
    /// - Parameter font: 字体
    public func setTitleFont(_ font: UIFont) {
        headerView.setFont(font)
    }
    
    public func setHeaderBackgroundView(_ headerBackgroundView: UIView) {
        headerView.addSubview(headerBackgroundView)
        headerView.sendSubviewToBack(headerBackgroundView)
    }
    
    /// 选中的底部横条的颜色
    ///
    /// - Parameter color: 颜色
    public func setSelectStyle( color:UIColor,height: CGFloat = 3,width: CGFloat = -1) {
       headerView.setSelectStyle(color: color,height: height, width: width)
    }
    
    /// 设置切换回调
    ///
    /// - Parameter block: 回调方法
    public func setSelectBlock(block: @escaping (Int)->Void) {
        selectBlock = block
    }
}




