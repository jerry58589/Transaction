//
//  InsertTransactionRequestModel.swift
//  Homework
//
//  Created by JerryLo on 2022/3/15.
//

import Foundation

struct TransactionRequestModel: Codable {
    let title: String
    let description: String
    let time: Int
    let details: [TransactionDetailRequestModel]
}

struct TransactionDetailRequestModel: Codable {
    let name: String
    let price: Int
    let quantity: Int
}
