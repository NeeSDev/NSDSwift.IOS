//
//  DataExtension.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    init(vert: CGFloat) {
        self.init()
        top = vert
        left = 0
        bottom = vert
        right = 0
    }
    
    init(horz: CGFloat) {
        self.init()
        top = 0
        left = horz
        bottom = 0
        right = horz
    }
    
    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }
    
    init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }
    
    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
    
    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }
}



extension String {
    func range(with range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

extension Date {
    
    func HHmmssFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
    
    func HHmmFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func yyyyMMddHHmmFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    func yyyyMMddFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
        
    static func getWeekDaysSortedByToday() -> ([String], [String] ,[String]) {
        let weekdays:[String] = ["日", "一", "二", "三", "四", "五", "六"]
        var calendar = Calendar.init(identifier: .chinese)
        calendar.timeZone = TimeZone(identifier:"Asia/Shanghai")!
        let theComponents = calendar.dateComponents([.weekday], from: Date())
        
        guard let weekday = theComponents.weekday else {
            return ([],[],[])
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let currentDate = Date()
        
        var resultWeekdays: [String] = []
        var resultWeekFomatters: [String] = []
        var resultWeekDates: [String] = []
        
        for (index,_) in weekdays.enumerated() {
            let dateString = formatter.string(from: Date(timeInterval: TimeInterval(60*60*24*index), since: currentDate))
            let dateArray = dateString.components(separatedBy: "-")
            
            resultWeekdays.append(weekdays[(weekday - 1 + index )%7])
            resultWeekFomatters.append("\(dateArray[1])-\(dateArray[2])")
            resultWeekDates.append(dateString)
        }
        
        return (resultWeekdays,resultWeekFomatters,resultWeekDates)
    }
}