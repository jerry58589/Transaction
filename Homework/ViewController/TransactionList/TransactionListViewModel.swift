//
//  TransactionListViewModel.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import RxSwift

class TransactionListViewModel {

    var disposeBag: DisposeBag = .init()
    private var transactions = [Transaction]()

    @Inject private var apiManager: APIManager
    @Inject private var dbManager: DBManager

    // #MARK: Api func
    func getTransactionListViewObjects() -> Single<TransactionListViewObject> {
        return apiManager.getTransactions().map { (transactions) -> TransactionListViewObject in
            #warning("DOTO: make TransactionListViewObject then sort sections by time OK")
            self.transactions = transactions
            let _ = self.updateDB()
            return self.genTransactionListViewObject(transactions: transactions)
        }.observe(on: MainScheduler.instance)
    }
    
    func deleteTransactionViewObject(id: Int) -> Single<TransactionListViewObject> {
        return apiManager.deleteTransaction(id: id).map { (transactions) -> TransactionListViewObject in
            self.transactions = transactions
            let _ = self.updateDB()
            return self.genTransactionListViewObject(transactions: transactions)
        }.observe(on: MainScheduler.instance)
    }
    
    // #MARK: DB func
    func testDB() {
        dbManager.test1()
    }
    
    func updateDB() -> Single<TransactionListViewObject> {
        return dbManager.updateTransactionList(transactions: transactions).map { (transactions) -> TransactionListViewObject in
            self.transactions = transactions
            return self.genTransactionListViewObject(transactions: transactions)
        }.observe(on: MainScheduler.instance)
    }
    
    func getDBTransactionListViewObject() -> Single<TransactionListViewObject> {
        return dbManager.getTransactionList().map { (transactions) -> TransactionListViewObject in
            self.transactions = transactions
            return self.genTransactionListViewObject(transactions: transactions)
        }.observe(on: MainScheduler.instance)
    }
    
    func deleteDBTransactionViewObject(id: Int) -> Single<TransactionListViewObject> {
        return dbManager.deleteTransaction(id: id).map { (transactions) -> TransactionListViewObject in
            self.transactions = transactions
            let _ = self.updateDB()
            return self.genTransactionListViewObject(transactions: transactions)
        }.observe(on: MainScheduler.instance)
    }

    // #MARK: other func
    private func genTransactionListViewObject(transactions: [Transaction]) -> TransactionListViewObject {
        var sections = [TransactionListSectionViewObject]()
        var sum = 0
        
        sections = transactions.map { (transaction) -> TransactionListSectionViewObject in
            let cells = transaction.details?.map { (detail) -> TransactionListCellViewObject in
                sum = (detail.quantity * detail.price) + sum
                let priceStr = detail.price.priceFormat
                let priceWithQuantity = "\(priceStr) x \(detail.quantity)"
                
                return .init(name: detail.name, priceWithQuantity: priceWithQuantity)
            } ?? []
            
            return TransactionListSectionViewObject(title: transaction.title, time: transaction.time.timestampDateStr, id: transaction.id, cells: cells)
        }
        
        sections = sections.sorted(by: {$0.time > $1.time})
        return .init(sum: sum, sections: sections)
    }
    
    
    func genTransactionDetailViewObject(id: Int) -> TransactionDetailViewObject {
        let transaction = self.transactions.filter {
            $0.id == id
        }.first
        
        let details = transaction?.details?.map({ (detail) -> InsertTransactionCellViewObject in
            return .init(name: detail.name, price: String(detail.price), quantity: String(detail.quantity))
        }) ?? []
                
        return .init(id: id, title: transaction?.title ?? "", description: transaction?.description ?? "", time: (transaction?.time.timestampDateStr ?? ""), details: details)
    }

}
