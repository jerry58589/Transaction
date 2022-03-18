//
//  APIManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

class APIManager {

    private static let host:String = "https://e-app-testing-z.herokuapp.com"
    private static let transaction:String = "/transaction"

    static let sharedInstance:APIManager = .init()

    func getTransactions() -> Single<[Transaction]> {
        return get().flatMap { (data) -> Single<[Transaction]> in
            return APIManager.handleDecode([Transaction].self, from: data)
        }
    }
    
    func deleteTransaction(id: Int) -> Single<[Transaction]> {
        return delete(id: id).flatMap { (data) -> Single<[Transaction]> in
            return APIManager.handleDecode([Transaction].self, from: data)
        }
    }
    
    func addTransaction(params: [String: AnyObject]) -> Single<[Transaction]> {
        return post(params: params).flatMap{ (data) -> Single<[Transaction]> in
            return APIManager.handleDecode([Transaction].self, from: data)
        }
    }
    
    func updateTransaction(id: Int, params: [String: AnyObject]) -> Single<[Transaction]> {
        return put(id: id, params: params).flatMap { (data) -> Single<[Transaction]> in
            return APIManager.handleDecode([Transaction].self, from: data)
        }
    }

    public enum DecodeError: Error, LocalizedError {
        case dataNull
        public var errorDescription: String? {
            switch self {
            case .dataNull:
                return "Data Null"
            }
        }
    }

    private static func handleDecode<T>(_ type: T.Type, from data: Data?) -> Single<T> where T: Decodable { 
        if let strongData = data {
            do {
                let toResponse = try JSONDecoder().decode(T.self ,from: strongData)
                return Single<T>.just(toResponse)
            } catch {
                return Single.error(error)
            }
        } else {
            return Single.error(DecodeError.dataNull)
        }
    }

    private func get() -> Single<Data?> {
        return Single<Data?>.create { (singleEvent) -> Disposable in
            Alamofire.Session.default.request(APIManager.host + APIManager.transaction, method: .get).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       print("JSONString = " + JSONString)
                    }
                    singleEvent(.success(response.data))
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }

    }
    
    private func delete(id: Int) -> Single<Data?> {
        return Single<Data?>.create { (singleEvent) -> Disposable in
            Alamofire.Session.default.request(APIManager.host + APIManager.transaction + "/\(id)", method: .delete).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       print("JSONString = " + JSONString)
                    }
                    singleEvent(.success(response.data))
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func post(params: [String: AnyObject]) -> Single<Data?> {
        let headers: HTTPHeaders? = [HTTPHeader(name: "Content-Type", value: "application/json")]

        return Single<Data?>.create { (singleEvent) -> Disposable in
            Alamofire.Session.default.request(APIManager.host + APIManager.transaction, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                if let httpBody = response.request?.httpBody, let JSONString = String(data: httpBody, encoding: String.Encoding.utf8) {
                    print("httpBody = " + JSONString)
                }
                
                switch response.result {
                case .success:
                    if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       print("JSONString = " + JSONString)
                    }
                    singleEvent(.success(response.data))
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func put(id: Int, params: [String: AnyObject]) -> Single<Data?> {
        let headers: HTTPHeaders? = [HTTPHeader(name: "Content-Type", value: "application/json")]

        return Single<Data?>.create { (singleEvent) -> Disposable in
            Alamofire.Session.default.request(APIManager.host + APIManager.transaction + "/\(id)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                if let httpBody = response.request?.httpBody, let JSONString = String(data: httpBody, encoding: String.Encoding.utf8) {
                    print("httpBody = " + JSONString)
                }
                
                switch response.result {
                case .success:
                    if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       print("JSONString = " + JSONString)
                    }
                    singleEvent(.success(response.data))
                case .failure(let error):
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
