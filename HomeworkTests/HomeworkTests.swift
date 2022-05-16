//
//  HomeworkTests.swift
//  HomeworkTests
//
//  Created by AlexanderPan on 2021/5/6.
//

import XCTest
@testable import Homework
import UIKit
import RxSwift
import RxCocoa

// We can't easily test the uikit compoment
// https://github.com/ReactiveX/RxSwift/blob/main/Tests/RxCocoaTests/UITextField+RxTests.swift

class HomeworkTests: XCTestCase {
    
    var vc: InsertTransactionViewController!
    var vm: InsertTransactionVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let (vc, vm) = makeSUT()
        self.vc = vc
        self.vm = vm
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.vc = nil
        self.vm = nil
    }

    func test_createTrx_should_not_send_if_all_empty() throws {
        let events = ViewModelEventsSpy(vm)
        
        let allEmpty = events.timeText.isEmpty && events.titleText.isEmpty && events.descriptionText.isEmpty
        XCTAssertTrue(allEmpty)
    }
    
    func test_createTrx_should_not_send_if_some_empty() throws {
        let events = ViewModelEventsSpy(vc.viewModel)
        
        vc.viewModel.title.accept("this is title")
        let hasEmpty1 = events.timeText.isEmpty || events.titleText.isEmpty || events.descriptionText.isEmpty
        XCTAssertTrue(hasEmpty1)
        
        vc.viewModel.description.accept("this is description")
        let hasEmpty2 = events.timeText.isEmpty || events.titleText.isEmpty || events.descriptionText.isEmpty
        XCTAssertTrue(hasEmpty2)
        
        vc.viewModel.time.accept("this is time")
        let hasEmpty3 = events.timeText.isEmpty || events.titleText.isEmpty || events.descriptionText.isEmpty
        XCTAssertFalse(hasEmpty3)
    }
    
    func test_createTrx_timestamp_is_illegal() throws {
        let events = ViewModelEventsSpy(vc.viewModel)
        let isoDateOrNot = "this is time"
        vc.viewModel.time.accept(isoDateOrNot)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
        
        let date: Date? = dateFormatter.date(from:events.timeText)
        XCTAssertNil(date)
    }
    
    func test_createTrx_timestamp_is_valid() throws {
        let events = ViewModelEventsSpy(vc.viewModel)
        let isoDateOrNot = "2016-04-14T10:44:00+0000"
        vc.viewModel.time.accept(isoDateOrNot)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date: Date? = dateFormatter.date(from:events.timeText)
        let isValid = dateFormatter.date(from:events.timeText) != nil ? true : false
        XCTAssertTrue(isValid)
    }
    
    private func makeSUT() -> (InsertTransactionViewController, InsertTransactionVM) {
        let repo: MyHomeworkRepo = MyHomeworkDataRepo.init(remoteDataSource: MyHomeworkRemoteDatasource.init())
        let vm = InsertTransactionVM(apiService: repo)
        let vc = InsertTransactionViewController(viewModel: vm)
        vc.loadViewIfNeeded()
//        vc.view.layoutSubviews()
        return (vc, vm)
    }
    
    private class ViewModelEventsSpy {
        private(set) var timeText = ""
        private(set) var titleText = ""
        private(set) var descriptionText = ""
        private(set) var canPressed: Bool = false
        private(set) var canSend: Bool = false

        private let disposeBag = DisposeBag()
        
        init(_ vm: InsertTransactionVM) {
            vm.time
                .subscribe(onNext: { [weak self] (time) in
                    guard let self = self else {return}
                    self.timeText = time
            }).disposed(by: disposeBag)
            
            vm.title
                .subscribe(onNext: { [weak self] (title) in
                    guard let self = self else {return}
                    self.titleText = title
            }).disposed(by: disposeBag)
            
            vm.description
                .subscribe(onNext: { [weak self] (description) in
                    guard let self = self else {return}
                    self.descriptionText = description
            }).disposed(by: disposeBag)
            
            vm.createTrxRequest
                .subscribe(onNext: { [weak self] (canSend) in
                    guard let self = self else {return}
                    self.canSend = canSend == InsertTransactionVM.action.ready ? true : false
            }).disposed(by: disposeBag)
            
            vm.canCreateTrx
                .subscribe(onNext: { [weak self] (canPressed) in
                    guard let self = self else {return}
                    self.canPressed = canPressed
            }).disposed(by: disposeBag)
            
        }
    }
    
}
