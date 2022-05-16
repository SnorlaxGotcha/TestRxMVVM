//
//  InsertTransactionVM.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/10.
//

import Foundation
import RxSwift
import RxCocoa

class InsertTransactionVM {
    
    enum action {
        case none
        case ready
        case onEdit
        case onProcess
    }
    
    let repo: MyHomeworkRepo!

    let title = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let description = BehaviorRelay<String>(value: "")
    let createTrxDTO = BehaviorRelay<CreateModifyTrxDTO>(value: .init(time: 0, title: "", description: "", details: nil))
    
    let canCreateTrx = BehaviorRelay<Bool>(value: false)
    let createTrxRequest = BehaviorRelay<action>(value: .none)

    init(apiService: MyHomeworkRepo) {
        self.repo = apiService
    }
    
}

class InsertBasicCellVM {
    
    var time: Int = 0
    let timeText = BehaviorRelay<Int>(value: 0)
    var title: String = ""
    let titleText = BehaviorRelay<String>(value: "")
    let description: String = ""
    let descriptionText = BehaviorRelay<String>(value: "")
    
    public let focus = PublishRelay<Void>()
    
}

class InsertDetailCellVM {
    
    public let name: String = ""
    public let nameText = BehaviorRelay<String>(value: "")
    public let price: Int = 0
    public let priceText = BehaviorRelay<Int>(value: 0)
    public let quantity: Int = 0
    public let dquantityText = BehaviorRelay<Int>(value: 0)
    
    public let focus = PublishRelay<Void>()

}
