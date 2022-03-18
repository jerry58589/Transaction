//
//  Encodable+Extension.swift
//  Homework
//
//  Created by JerryLo on 2022/3/16.
//

import Foundation

extension Encodable {
    var dict: [String: AnyObject] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else { return [:] }
        return json
    }
}
