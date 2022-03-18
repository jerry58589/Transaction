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

class InsertTransactionViewModel {

    var disposeBag:DisposeBag = .init()

    @Inject private var apiManager: APIManager

    func addTransactionViewObject(viewObject: InsertTransactionViewObject) -> Single<String> {
        return apiManager.addTransaction(params: genTransactionRequestDic(viewObject)).map { (transactions) -> String in
            return "okok"
        }.observe(on: MainScheduler.instance)
    }
    
    private func genTransactionRequestDic(_ viewObject: InsertTransactionViewObject) -> [String: AnyObject] {
        
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity) ?? 0) != 0 && (Int($0.price) ?? 0) != 0
        }.map { detail -> TransactionDetailRequestModel in
            return TransactionDetailRequestModel(name: detail.name, price: Int(detail.price)!, quantity: Int(detail.quantity)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: [])
        
        var requestModelDic = requestModel.dict
        
        let requestDetailsDicArr = requestDetails.map { detail -> [String: AnyObject] in
            return detail.dict
        }
        
        requestModelDic.updateValue(requestDetailsDicArr as AnyObject, forKey: "details")
        
        return requestModelDic
        
    }

    
    private func genInsertTransactionRequestDic_old(_ viewObject: InsertTransactionViewObject) -> [String: Any] {
        
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity) ?? 0) != 0 && (Int($0.price) ?? 0) != 0
        }.map { detail -> TransactionDetailRequestModel in
            return TransactionDetailRequestModel(name: detail.name, price: Int(detail.price)!, quantity: Int(detail.quantity)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: requestDetails)
        
        return requestModel.dictionaryyy ?? [String: Any]()
    }
}
