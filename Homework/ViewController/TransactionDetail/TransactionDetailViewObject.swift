//
//  TransactionDetailViewObject.swift
//  Homework
//
//  Created by JerryLo on 2022/3/16.
//

import Foundation

struct TransactionDetailViewObject: Codable {
    let id: Int
    var title: String = ""
    var description: String = ""
    var time: String = ""
    var details: [InsertTransactionCellViewObject] = []
}

//struct TransactionDetailCellViewObject: Codable {
//    var name: String = ""
//    var price: String = ""
//    var quantity: String = ""
//}
