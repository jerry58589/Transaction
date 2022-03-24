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
    @Inject private var dbManager: DBManager

    // #MARK: Api func
    private func editApiTransactionViewObject(viewObject: TransactionDetailViewObject) -> Single<ApiStatus> {
        
        return apiManager.updateTransaction(id: viewObject.id, params: genTransactionRequestDic(viewObject)).map { (transactions) -> ApiStatus in
            return .success
        }.observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    // #MARK: DB func
    private func editDBTransactionViewObject(viewObject: TransactionDetailViewObject) -> Single<ApiStatus> {
        return dbManager.updateTransaction(transaction: genTransaction(viewObject)).map { (transactions) -> ApiStatus in
            return .success
        }.observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }

    // #MARK: other func
    func editTransactionViewObject(viewObject: TransactionDetailViewObject) -> Single<ApiStatus> {
        if AppDelegate.hasNetwork {
            return editApiTransactionViewObject(viewObject: viewObject)
        }
        else {
            return editDBTransactionViewObject(viewObject: viewObject)
        }
    }
    
    private func genTransactionRequestDic(_ viewObject: TransactionDetailViewObject) -> [String: AnyObject] {
        
        let requestDetails = viewObject.details.filter {
            return (Int($0.quantity)) != 0 && (Int($0.price)) != 0
        }.map { detail -> TransactionDetail in
            return TransactionDetail(name: detail.name, quantity: Int(detail.quantity)!, price: Int(detail.price)!)
        }
        
        let requestModel = TransactionRequestModel(title: viewObject.title, description: viewObject.description, time: viewObject.time.dateStringToTimestamp(), details: requestDetails)
        
        return requestModel.dict
    }
    
    private func genTransaction(_ viewObject: TransactionDetailViewObject) -> Transaction {
        let transactionDetails = viewObject.details.filter {
            return (Int($0.quantity) ?? 0) != 0 && (Int($0.price) ?? 0) != 0
        }.map { detail -> TransactionDetail in
            return .init(name: detail.name, quantity: Int(detail.price)!, price: Int(detail.quantity)!)
        }
        
        let transaction = Transaction.init(id: viewObject.id, time: viewObject.time.dateStringToTimestamp(), title: viewObject.title, description: viewObject.description, details: transactionDetails)
        
        return transaction
    }

}

