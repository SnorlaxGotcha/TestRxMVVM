//
//  InsertTransactionViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class InsertTransactionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel: InsertTransactionVM
    
    let timeTextField: UITextField = {
        let v = UITextField()
        v.keyboardType = .default
        v.borderStyle = .roundedRect
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let timeLabel: UILabel = {
        let v = UILabel()
        v.text = "TIME"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let titleField: UITextField = {
        let v = UITextField()
        v.keyboardType = .default
        v.borderStyle = .roundedRect
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let titleLabel: UILabel = {
        let v = UILabel()
        v.text = "TITLE"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let descriptionTextField: UITextField = {
        let v = UITextField()
        v.keyboardType = .default
        v.borderStyle = .roundedRect
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "DESCRIPTION"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let addDetailButton = UIButton()
    let addButton: UIButton = {
        let v = UIButton()
        v.setTitle("ADD", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
        
    private var tableView: UITableView
    

    // MARK: - Constructor
    init(viewModel: InsertTransactionVM) {
        self.viewModel = viewModel
        self.tableView = UITableView(frame: .zero, style: .plain)
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
extension InsertTransactionViewController {
    
    private func initView() {
        view.backgroundColor = .white
                
        self.view.addSubview(timeLabel)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
        
        self.view.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {  [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(16)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(timeTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
        
        self.view.addSubview(titleField)
        titleField.snp.makeConstraints {  [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.setContentHuggingPriority(.required, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        descriptionLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
        
        self.view.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints {  [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(descriptionLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(16)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        addButton.snp.makeConstraints { [weak self] make in
            guard let self = self else {return}
            make.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(BasicCell.self, forCellReuseIdentifier: "BasicCell")
        tableView.register(AdditionalCell.self, forCellReuseIdentifier: "AdditionalCell")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self] make in
            guard let self = self else {return}
            make.top.equalTo(descriptionTextField.snp.bottom).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(addButton.snp.top)
        }
        
    }
    
    func bindViewModel() {
        
        let vm = self.viewModel
        
        Observable.combineLatest(vm.time, vm.title, vm.description)
            .subscribe(onNext: { [weak self] (time, title, description) in
                // 只需要監聽全部的數值都有填入的狀態, 若數值缺少根本就不應該發送api更新.
                if time.isEmpty || title.isEmpty || description.isEmpty {
                    return
                }
                self?.viewModel.canCreateTrx.accept(true)
        }).disposed(by: disposeBag)
        
        vm.canCreateTrx
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] canCreateTrx in
                guard let self = self else {return}
                self.addButton.isUserInteractionEnabled = canCreateTrx
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(vm.canCreateTrx, vm.createTrxRequest, vm.createTrxDTO)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (canCreateTrx, createTrx, body) in
                guard let self = self else {return}
                if canCreateTrx, createTrx == .ready {
                    // 打ＡＰＩ的動畫, 阻擋前景動作之類的ＵＩ/ＵＸ
                    self.viewModel.createTrxRequest.accept(.onProcess)
                    //
                    self.viewModel.repo.addTransaction(requestBody: body)
                        .observe(on: MainScheduler.asyncInstance)
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
                        .disposed(by: self.disposeBag)
                    
                }
            })
            .disposed(by: disposeBag)

        
        vm.time
            .bind(to: timeTextField.rx.text)
            .disposed(by: disposeBag)
        
        timeTextField.rx.text
            .orEmpty
            .bind(to: vm.time)
            .disposed(by: disposeBag)
        
        vm.title
            .bind(to: titleField.rx.text)
            .disposed(by: disposeBag)
        
        titleField.rx.text
            .orEmpty
            .bind(to: vm.title)
            .disposed(by: disposeBag)
        
        vm.description
            .bind(to: descriptionTextField.rx.text)
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.text
            .orEmpty
            .bind(to: vm.description)
            .disposed(by: disposeBag)

    }
    
    @objc func pressed() {
        print("pressedpressedpressed")
        viewModel.createTrxRequest.accept(.ready)
    }
    
}

// MARK:- Tableview
extension InsertTransactionViewController: UITableViewDelegate {}
