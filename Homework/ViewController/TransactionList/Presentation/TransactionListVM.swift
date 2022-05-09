//
//  TransactionListVM.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/10.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionListVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    private let repo: MyHomeworkRepo!
    let totalCost = BehaviorRelay<String>(value: "$ 0")
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Output
    let data: Observable<[GetTrxDTO]>
    
    init(apiService: MyHomeworkRepo) {
        self.repo = apiService
        
        let listRelay = BehaviorRelay<[GetTrxDTO]>(value: [])
        data = listRelay.asObservable().share()
        
        data.observe(on: MainScheduler.instance)
            .subscribe { [weak self] events in
                guard let self = self else {return}
                var sum = 0
                events.map { items in
                    for item in items {
                        if let detail = item.details {
                            sum += detail.reduce(0) { sum, detailItem in
                                return sum + (detailItem.price * detailItem.quantity)
                            }
                        }
                    }
                }
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                let moneyString = formatter.string(from: NSNumber(value: sum)) ?? "$0"
                self.totalCost.accept("總花費 \(moneyString)")
            }.disposed(by: disposeBag)

        // TODO: Maybe need a interactor to seperae logic and behavior.
        repo.getAllTransactions()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { postsList in
//                print("List of posts:", postsList)
                listRelay.accept(postsList)
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
