//
//  TransactionDetailViewModel.swift
//  Homework
//
//  Created by JerryLo on 2022/3/16.
//

import Foundation
import RxSwift

class TransactionDetailViewModel {

    var disposeBag:DisposeBag = .init()

    @Inject private var apiManager: APIManager
    
    func editTransactionViewObject(viewObject: TransactionDetailViewObject) -> Single<String> {
        
        return apiManager.updateTransaction(id: viewObject.id, params: genTransactionRequestDic(viewObject)).map { (transactions) -> String in
            return "okok"
        }.observe(on: MainScheduler.instance)
    }

    private func genTransactionRequestDic(_ viewObject: TransactionDetailViewObject) -> [String: Any] {
        
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity)) != 0 && (Int($0.price)) != 0
        }.map { detail -> TransactionDetailRequestModel in
            return TransactionDetailRequestModel(name: detail.name, price: Int(detail.price)!, quantity: Int(detail.quantity)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: requestDetails)
        
        
        
        return requestModel.dictionaryyy ?? [String: Any]()
    }
    
    func editTransactionViewObject2(viewObject: TransactionDetailViewObject) -> Single<String> {
        
        return apiManager.updateTransaction2(id: viewObject.id, params: genTransactionRequestDic2(viewObject)).map { (transactions) -> String in
            return "okok"
        }.observe(on: MainScheduler.instance)
    }

    private func genTransactionRequestDic2(_ viewObject: TransactionDetailViewObject) -> [String: AnyObject] {
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity)) != 0 && (Int($0.price)) != 0
        }.map { detail -> TransactionDetailRequestModel in
            return TransactionDetailRequestModel(name: detail.name, price: Int(detail.price)!, quantity: Int(detail.quantity)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: requestDetails)

        return requestModel.dict
    }
}

extension Encodable {
    var dict: [String: AnyObject] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else { return [:] }
        return json
    }
}

