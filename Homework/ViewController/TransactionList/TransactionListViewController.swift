//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit

//
import RxCocoa
import RxSwift

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

class TransactionListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: TransactionListVM

    private var totalCost: UILabel
    private var tableView: UITableView
    private var addButton: UIButton

    // MARK: - Constructor
    init(viewModel: TransactionListVM) {
        self.viewModel = viewModel
        self.totalCost = UILabel()
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.addButton = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
    }
    
}

// MARK:- Views
extension TransactionListViewController {
    private func initView() {
        view.backgroundColor = .red
        
        self.view.addSubview(totalCost)
        totalCost.translatesAutoresizingMaskIntoConstraints = false
        totalCost.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().offset(16)
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(FieldCell.self, forCellReuseIdentifier: "FieldCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(totalCost.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        addButton.backgroundColor = .darkGray
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.right.equalToSuperview().offset(-20)
        }
    }
    
    func bindViewModel() {
        
        totalCost.text = "totalCosttotalCost"
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.totalCost
            .bind(to: totalCost.rx.text)
            .disposed(by: disposeBag)

        viewModel.data
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell") as? FieldCell else { return UITableViewCell() }
                cell.setViewModel(element)
                return cell
        }
        .disposed(by: disposeBag)
        
        
        addButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.isSelected.accept(!self.viewModel.isSelected.value)
        }.disposed(by: disposeBag)
        
        viewModel.isSelected
            .asObservable()
            .subscribe { [weak self] isSelected in
                print("isSelected is \(isSelected)")
                
            }.disposed(by: disposeBag)

        
    }
}

// MARK:- Tableview
extension TransactionListViewController: UITableViewDelegate {}

// MARK:- Test
extension TransactionListViewController {
    
    private func testUpdate() {
        let repo: MyHomeworkRepo = MyHomeworkDataRepo.init(remoteDataSource: MyHomeworkRemoteDatasource.init())
        
        let body = CreateModifyTrxDTO.init(time: Int(Date().timeIntervalSince1970), title: "防疫大採購2", description: "買買666677", details: nil)
        
        repo.updateTransaction(transactionId: 802, requestBody: body)
            .observe(on: MainScheduler.instance)
            .subscribe {postsList in
                print("List of posts:", postsList)
            } onError: {error in
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
            } onCompleted: {
                print("done")
            }.disposed(by: disposeBag)

        
        repo.addTransaction(requestBody: body)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { postsList in
                print("List of posts:", postsList)
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
    
    private func testDelete() {
        let repo: MyHomeworkRepo = MyHomeworkDataRepo.init(remoteDataSource: MyHomeworkRemoteDatasource.init())
        
        repo.deleteTransaction(transactionId: 740)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { postsList in
                print("List of posts:", postsList)
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
    
    private func testInsert() {
        let repo: MyHomeworkRepo = MyHomeworkDataRepo.init(remoteDataSource: MyHomeworkRemoteDatasource.init())

        let body = CreateModifyTrxDTO.init(time: Int(Date().timeIntervalSince1970), title: "防疫大採購2", description: "買買6666", details: nil)
        
        repo.addTransaction(requestBody: body)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { postsList in
                print("List of posts:", postsList)
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
    
    private func testApiClient() {
        
        let repo: MyHomeworkRepo = MyHomeworkDataRepo.init(remoteDataSource: MyHomeworkRemoteDatasource.init())
        
        repo.getAllTransactions()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { postsList in
                print("List of posts:", postsList)
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
