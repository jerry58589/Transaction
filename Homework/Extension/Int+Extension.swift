//
//  Int+Extension.swift
//  Homework
//
//  Created by JerryLo on 2022/3/11.
//

import Foundation

extension Int {    
    var priceFormat: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "Zh_TW")
        
        let priceStr = formatter.string(from: NSNumber(value: self)) ?? "$0"

        return priceStr
    }
    
    var timestampDateStr: String {
        let timeInterval = TimeInterval(self)
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd"
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .republicOfChina)

        return dateFormatter.string(from: date)
    }
}
