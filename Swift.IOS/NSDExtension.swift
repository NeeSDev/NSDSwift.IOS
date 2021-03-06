//
//  DataExtension.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

import UIKit

public extension UIScreen {
    class var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    class var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}

public extension UIColor {
    static func color(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static func colorAlpha(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

public extension CGColor {
    class var black: CGColor {
        return UIColor.black.cgColor
    }
    
    class var gray: CGColor {
        return UIColor.gray.cgColor
    }
    
    class var darkGray: CGColor {
        return UIColor.darkGray.cgColor
    }
    
    class var yellow: CGColor {
        return UIColor.yellow.cgColor
    }
    
    class var red: CGColor {
        return UIColor.red.cgColor
    }
    
    static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> CGColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor
    }
    
    static func colorAlpha(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> CGColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha).cgColor
    }
}

public extension UIEdgeInsets {
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



public extension String {
    func range(with range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

public extension Date {
    
    func formatter_HHmmss() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH: mm: ss"
        return formatter.string(from: self)
    }
    
    func formatter_HHmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH: mm"
        return formatter.string(from: self)
    }
    
    func formatter_yyyyMMddHHmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH: mm"
        return formatter.string(from: self)
    }
    
    func formatter_yyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    static func getWeekDaysSortedByToday() -> ([String], [String] , [String]) {
        let weekdays: [String] = ["日", "一", "二", "三", "四", "五", "六"]
        var calendar = Calendar.init(identifier: .chinese)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
        let theComponents = calendar.dateComponents([.weekday], from: Date())
        
        guard let weekday = theComponents.weekday else {
            return ([], [], [])
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let currentDate = Date()
        
        var resultWeekdays: [String] = []
        var resultWeekFomatters: [String] = []
        var resultWeekDates: [String] = []
        
        for (index, _) in weekdays.enumerated() {
            let dateString = Date(timeInterval: TimeInterval(60*60*24*index), since: currentDate).formatter_yyyyMMdd()
            let dateArray = dateString.components(separatedBy: "-")
            
            resultWeekdays.append(weekdays[(weekday - 1 + index )%7])
            resultWeekFomatters.append("\(dateArray[1])-\(dateArray[2])")
            resultWeekDates.append(dateString)
        }
        
        return (resultWeekdays, resultWeekFomatters, resultWeekDates)
    }
}

public extension UIImage {
    func fixOrientation() -> UIImage {
        
        if imageOrientation == .up {
            return self
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        let transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform.translatedBy(x: self.size.width, y: self.size.height)
            transform.rotated(by: .pi)
            break;
                
        case .left, .leftMirrored:
            transform.translatedBy(x: self.size.width, y: 0)
            transform.rotated(by: .pi/2)
            break;
                
                
        case .right, .rightMirrored:
            transform.translatedBy(x: 0, y: self.size.height)
            transform.rotated(by: -.pi/2)
            break;
        case .up, .upMirrored:
            break;
        @unknown default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: self.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break;
                
            case .leftMirrored, .rightMirrored:
                transform.translatedBy(x: self.size.height, y: 0)
                transform.scaledBy(x: -1, y: 1)
                break;
                
        case .up, .down, .left, .right:
            break;
        @unknown default:
            break
        }
        
        guard let cgImage = cgImage,
              let colorSpace = cgImage.colorSpace else {
            return self
        }

        let context: CGContext = CGContext(data: nil,
                                               width: Int(size.width),
                                               height: Int(size.height),
                                               bitsPerComponent: cgImage.bitsPerComponent,
                                               bytesPerRow: 0,
                                               space: colorSpace,
                                               bitmapInfo: cgImage.bitmapInfo.rawValue)!
                                       
        context.concatenate(transform);
        
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break;
        default:
            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = context.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img;
    }
    
    
    func compress(to fileSize: Int) -> Data{
        var compression: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compression)!
        //每次减少的比例
        let scale: CGFloat = 0.1;
        
        //循环条件：没到最小压缩比例，且没压缩到目标大小
        while (compression > 0) && (imageData.count > fileSize) {
            compression -= scale;
            imageData = self.jpegData(compressionQuality: compression)!
        }
        return imageData;
    }
}
