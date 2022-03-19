//
//  DBManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation
import FMDB
import RxSwift

#warning("DOTO: DBManager OK")

class DBManager {
    static let sharedInstance:DBManager = .init()
    var existsID = [Int]()
    private let databaseName = "TransactionDB.db"
    private let transactionTableName = "TransactionTable"
    private let detailTableName = "DetailTable"

    lazy private var dbURL: URL = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(databaseName)
        print("DB: Database url =", fileURL)
        return fileURL
    }()
     
    lazy private var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
        
    func updateTransactionList(transactions: [Transaction]) -> Single<[Transaction]> {
        db_openDB()
        db_clearTransactionTable()
        db_clearDetailTable()
        transactions.forEach {
            db_insertTransaction(transaction: $0)
        }
        db_closeDB()
        
        return getTransactionList()
    }
    
    func getTransactionList() -> Single<[Transaction]> {
        db_openDB()
        let selectTransactions = db_selectTransactions()
        db_closeDB()
        
        return Single.create { single in
            single(.success(selectTransactions))
            return Disposables.create()
        }
    }
    
    func deleteTransaction(id: Int) -> Single<[Transaction]> {
        db_openDB()
        db_deleteTransaction(id: id)
        
        let selectTransactions = db_selectTransactions()
        db_closeDB()
        
        return Single.create { single in
            single(.success(selectTransactions))
            return Disposables.create()
        }
    }
    
    func addTransaction(transaction: Transaction) -> Single<[Transaction]> {
        db_openDB()
        db_insertTransaction(transaction: transaction)
        db_closeDB()
        
        return getTransactionList()
    }
    
    func updateTransaction(transaction: Transaction) -> Single<[Transaction]> {
        db_openDB()
        db_updateTransaction(transaction: transaction)
        db_closeDB()
        
        return getTransactionList()
    }
    
    // #MARK: private DB func
    private func db_openDB() {
        if db.open() {
            print("DB: \(databaseName) is open.")
            db_createTransactionTable()
            db_createDetailTable()
        } else {
            print("DB: Database can not open: \(db.lastErrorMessage())")
        }
    }
    
    private func db_closeDB() {
        db.close()
    }
    
    private func db_createTransactionTable() {
        let sql = "CREATE TABLE IF NOT EXISTS \(transactionTableName)(" +
            "id INTEGER UNIQUE," +
            "time INTEGER NOT NULL," +
            "title TEXT NOT NULL," +
            "description TEXT NOT NULL" +
            ");"
        if db.executeStatements(sql) {
            print("DB: \(transactionTableName) is created.")
        } else {
            print("DB: \(transactionTableName) create failed.")
        }
    }
    
    private func db_createDetailTable() {
        let sql = "CREATE TABLE IF NOT EXISTS \(detailTableName)(" +
            "id INTEGER NOT NULL," +
            "name TEXT NOT NULL," +
            "quantity INTEGER NOT NULL," +
            "price INTEGER NOT NULL" +
            ");"
        if db.executeStatements(sql) {
            print("DB: \(detailTableName) is created.")
        } else {
            print("DB: \(detailTableName) create failed.")
        }
    }

    private func db_insertTransaction(transaction: Transaction) {
        let sql = "INSERT or REPLACE INTO \(transactionTableName)(id, time, title, description) VALUES (?, ?, ?, ?)"
        let values: [Any] = [transaction.id, transaction.time, transaction.title, transaction.description]

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: values) {
                print("DB: \(transactionTableName) id = \(transaction.id) insert success.")
            }
            else {
                print("DB: \(transactionTableName) insert failed.")
            }
        }
        
        transaction.details?.forEach {
            db_insertDetail(id: transaction.id, detail: $0)
        }
    }
    
    private func db_insertDetail(id: Int, detail: TransactionDetail) {
        let aql = "INSERT or REPLACE INTO \(detailTableName)(id, name, quantity, price) VALUES (?, ?, ?, ?)"
        let values: [Any] = [id, detail.name, detail.quantity, detail.price]
        
        if db.open() {
            if db.executeUpdate(aql, withArgumentsIn: values) {
                print("DB: \(detailTableName) id = \(id) insert success.")
            }
            else {
                print("DB: \(detailTableName) insert failed.")
            }
        }
    }
    
    private func db_updateTransaction(transaction: Transaction) {        
        let sql = "UPDATE \(transactionTableName) SET " +
            "time = ?, title = ?, description = ? " +
            "WHERE id = ?;"

        let values: [Any] = [transaction.time, transaction.title, transaction.description, transaction.id]

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: values) {
                print("DB: \(transactionTableName) update success.")
            }
            else {
                print("DB: \(transactionTableName) update failed.")
            }
        }
        
        db_deleteDetail(id: transaction.id)
        
        transaction.details?.forEach {
            db_insertDetail(id: transaction.id, detail: $0)
        }
    }
        
    private func db_selectTransactions() -> [Transaction] {
        let sql = "SELECT * FROM \(self.transactionTableName)"
        var transactions = [Transaction]()
        
        if self.db.open() {
            if let result = self.db.executeQuery(sql, withArgumentsIn: []) {
                print("DB: \(self.transactionTableName) select success.")
                
                while result.next() {
                    let id = Int(result.int(forColumn: "id"))
                    let time = Int(result.int(forColumn: "time"))
                    let title = result.string(forColumn: "title") ?? ""
                    let description = result.string(forColumn: "description") ?? ""
                    
                    let details = self.db_selectDetails(id: id)
                    
                    transactions.append(Transaction.init(id: id, time: time, title: title, description: description, details: details))
                    
                    print("DB: \(self.transactionTableName) select =", id, time, title, description)
                }
            }
        }
        
        existsID = transactions.map { (transaction) -> Int in
            return transaction.id
        }
        
        return transactions
    }
    
    private func db_selectDetails(id: Int) -> [TransactionDetail] {
        let sql = "SELECT * FROM \(detailTableName) WHERE id = \(id)"
        var details = [TransactionDetail]()
        
        if db.open() {
            if let result = db.executeQuery(sql, withArgumentsIn: []) {
                print("DB: \(detailTableName) select success.")

                while result.next() {
                    let name = result.string(forColumn: "name") ?? ""
                    let quantity = Int(result.int(forColumn: "quantity"))
                    let price = Int(result.int(forColumn: "price"))

                    print("DB: \(self.detailTableName) select =", id, name, quantity, price)
                    details.append(TransactionDetail.init(name: name, quantity: quantity, price: price))
                }
            } else {
                print("DB: \(detailTableName) select failed.")
            }
        }
        
        return details
    }
        
    private func db_deleteTransaction(id: Int) {
        let sql = "DELETE FROM \(transactionTableName) WHERE id = \(id);"

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []) {
                print("DB: \(transactionTableName) id = \(id) delete success.")
            }
            else {
                print("DB: \(transactionTableName) id = \(id) delete failed.")
            }
        }
    }
    
    private func db_deleteDetail(id: Int) {
        let sql = "DELETE FROM \(detailTableName) WHERE id = \(id);"

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []) {
                print("DB: \(detailTableName) id = \(id) delete success.")
            }
            else {
                print("DB: \(detailTableName) id = \(id) delete failed.")
            }
        }
    }
    
    private func db_clearTransactionTable() {
        let sql = "DELETE FROM \(transactionTableName);"

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []) {
                print("DB: \(transactionTableName) clear success.")
            }
            else {
                print("DB: \(transactionTableName) clear failed.")
            }
        }
    }
    
    private func db_clearDetailTable() {
        let sql = "DELETE FROM \(detailTableName);"

        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []) {
                print("DB: Detail clear success.")
            }
            else {
                print("DB: Detail clear failed.")
            }
        }
    }
    
    
}
