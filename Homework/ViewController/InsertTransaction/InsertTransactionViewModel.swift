//
//  InsertTransactionViewModel.swift
//  Homework
//
//  Created by JerryLo on 2022/3/15.
//

import Foundation
import RxSwift

enum TextFieldIdentifier: String {
    case title = "title"
    case description = "description"
    case time = "time"
    case name = "name"
    case price = "price"
    case quantity = "quantity"
}

enum ApiStatus {
    case success
    case failed
}

class InsertTransactionViewModel {

    var disposeBag:DisposeBag = .init()

    @Inject private var apiManager: APIManager
    @Inject private var dbManager: DBManager

    // #MARK: Api func
    func addTransactionViewObject(viewObject: InsertTransactionViewObject) -> Single<ApiStatus> {
        return apiManager.addTransaction(params: genTransactionRequestDic(viewObject)).map { (transactions) -> ApiStatus in
            return .success
        }.observe(on: MainScheduler.instance)
    }
    
    // #MARK: DB func
    func addDBTransactionViewObject(viewObject: InsertTransactionViewObject) -> Single<ApiStatus> {
        return dbManager.addTransaction(transaction: genTransaction(viewObject)).map { (transactions) -> ApiStatus in
            return .success
        }.observe(on: MainScheduler.instance)
    }
    
    // #MARK: other func
    private func genTransactionRequestDic(_ viewObject: InsertTransactionViewObject) -> [String: AnyObject] {
        
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity) ?? 0) != 0 && (Int($0.price) ?? 0) != 0
        }.map { detail -> TransactionDetail in
            return TransactionDetail(name: detail.name, quantity: Int(detail.quantity)!, price: Int(detail.price)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: requestDetails)
        
        return requestModel.dict
    }
    
    private func genTransaction(_ viewObject: InsertTransactionViewObject) -> Transaction {
        let transactionDetails = viewObject.details.filter {
            return (Int($0.quantity) ?? 0) != 0 && (Int($0.price) ?? 0) != 0
        }.map { detail -> TransactionDetail in
            return .init(name: detail.name, quantity: Int(detail.price)!, price: Int(detail.quantity)!)
        }
        
        let id = (dbManager.existsID.max() ?? 999) + 1
        let transaction = Transaction.init(id: id, time: viewObject.time.dateStringToTimestamp(), title: viewObject.title, description: viewObject.description, details: transactionDetails)
        
        return transaction
    }
    
}
