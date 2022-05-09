//
//  MyHomeworkRepo.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import Foundation
import RxSwift

/**
 根據不同 Domain 定義不同的 Repository,
 Repository 為實際 Viewmodel / Interactor 實際取得資料的操作介面.
*/
protocol MyHomeworkRepo {
    func getAllTransactions() -> Observable<[GetTrxDTO]>
    func addTransaction(requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]>
    func updateTransaction(transactionId: Int, requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]>
    func deleteTransaction(transactionId: Int) -> Observable<[GetTrxDTO]>
}

/**
 根據不同 Domain 定義不同的 Repository,
 DataRepo 為實際實作 Repository的部分,
 對於 Viewmodel 來說, 不需要去知道實際資料的來源,
 由 DataRepo 去做 network / local / momery cache / disk cache 之類的資料操作.
*/
struct MyHomeworkDataRepo: MyHomeworkRepo {
    private let remoteDataSource: MyHomeworkDataLoader
    
    public init(remoteDataSource: MyHomeworkDataLoader) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getAllTransactions() -> Observable<[GetTrxDTO]> {
        return remoteDataSource.getAllTransactions()
    }
    
    func addTransaction(requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]> {
        return remoteDataSource.addTransaction(requestBody: requestBody)
    }
    
    func updateTransaction(transactionId: Int, requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]> {
        return remoteDataSource.updateTransaction(transactionId: transactionId, requestBody: requestBody)
    }
    
    func deleteTransaction(transactionId: Int) -> Observable<[GetTrxDTO]> {
        return remoteDataSource.deleteTransaction(transactionId: transactionId)
    }
    
}

/**
 實際上執行 API 操作的介面,
 實作部分可能會因為 API 設計不是由前端驅動 or 第三方 API 造成資料格式需要再處理過才能用,
 由 DataLoader 實作的部分做資料處理 / 封裝.
 */
protocol MyHomeworkDataLoader {
    func getAllTransactions() -> Observable<[GetTrxDTO]>
    func addTransaction(requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]>
    func updateTransaction(transactionId: Int, requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]>
    func deleteTransaction(transactionId: Int) -> Observable<[GetTrxDTO]>
}

/**
 這邊是實作呼叫 API 的地方,
 協作時, 可以先實作一個假的 DataLoader 給串接UI 的同仁使用.
 */
struct MyHomeworkRemoteDatasource: MyHomeworkDataLoader {
    
    func getAllTransactions() -> Observable<[GetTrxDTO]> {
        return APIManager.request(APIRouter.getAll)
    }
    
    func addTransaction(requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]> {
        return APIManager.request(APIRouter.add(requestBody: requestBody))
    }
    
    func updateTransaction(transactionId: Int, requestBody: CreateModifyTrxDTO) -> Observable<[GetTrxDTO]> {
        return APIManager.request(APIRouter.edit(transactionId: transactionId, requestBody: requestBody))
    }
    
    func deleteTransaction(transactionId: Int) -> Observable<[GetTrxDTO]> {
        return APIManager.request(APIRouter.delete(transactionId: transactionId))
    }
  
}
