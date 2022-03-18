//
//  InsertTransactionViewObject.swift
//  Homework
//
//  Created by JerryLo on 2022/3/14.
//

import Foundation

struct InsertTransactionViewObject: Codable {
    var title: String = ""
    var description: String = ""
    var time: String = ""
    var details: [InsertTransactionCellViewObject] = []
}

struct InsertTransactionCellViewObject: Codable {
    var name: String = ""
    var price: String = ""
    var quantity: String = ""
}

