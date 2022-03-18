//
//  String+Extension.swift
//  Homework
//
//  Created by JerryLo on 2022/3/16.
//

import Foundation

extension String {
    func dateStringToTimestamp(dateFormat: String = "yyyy/MM/dd") -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .republicOfChina)
        dateFormatter.dateFormat = dateFormat
        return Int((dateFormatter.date(from: self) ?? Date()).timeIntervalSince1970)
    }
}
