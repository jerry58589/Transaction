//
//  Encodable+Extension.swift
//  Homework
//
//  Created by JerryLo on 2022/3/16.
//

import Foundation

extension Encodable {
    var dictionaryyy: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
