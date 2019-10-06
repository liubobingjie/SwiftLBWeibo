//
//  NSDate+Category.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension Date{
   public func sinaDateto(string: String) -> Date?
   {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        return formatter.date(from: string)! as Date
    }
    
   public var dateDesctiption: String{
        let cal = Calendar.current
        if cal.isDateInToday(self)
        {
            let delta = Int(Date().timeIntervalSince(self))
            if delta < 60
            {
                return "刚刚"
            }
            if delta < 60 * 60
            {
                 return "\(delta/60)分钟前"
            }
            
              return "\(delta / (60 * 60)) 小时前"
        }
        
        /// 日期格式字符串
        var fmtString = " HH:mm"
        
        if cal.isDateInTomorrow(self)
        {
            fmtString = "昨天" + fmtString
        }else
        {
           fmtString = "MM-dd" + fmtString
            
           let coms = cal.component(Calendar.Component.year, from: self)
            if coms > 0 {
                fmtString = "yyyy-" + fmtString
            }
            
        }
        let df = DateFormatter()
        df.locale = NSLocale(localeIdentifier:"en") as Locale
        df.dateFormat = fmtString
        return df.string(from: self)
        
        
        
    }
}
