//
//  AdditionalCell.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import UIKit
import RxSwift
import SnapKit

class AdditionalCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    let inputTextField1 = UITextField()
    let cellTitleLabel1 = UILabel()
    let inputTextField2 = UITextField()
    let cellTitleLabel2 = UILabel()
    let inputTextField3 = UITextField()
    let cellTitleLabel3 = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
        
    func setViewModel(_ vm: InsertBasicCellVM) {
//        vm.text
//            .bind(to: inputTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        inputTextField.rx.text
//            .orEmpty
//            .skip(1)
//            .bind(to: vm.text)
//            .disposed(by: disposeBag)
//
//        focusButton.rx.tap
//            .bind(to: vm.focus)
//            .disposed(by: disposeBag)
//
//        cellTitleLabel.text = vm.title
    }
    
    private func setup() {
        cellTitleLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellTitleLabel1)
        
        inputTextField1.keyboardType = .default
        inputTextField1.inputAccessoryView = nil
        inputTextField1.borderStyle = .roundedRect
        inputTextField1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(inputTextField1)
        
        cellTitleLabel1.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().offset(16)
            make.top.bottom.leading.equalToSuperview().offset(16)
        }
        
        inputTextField1.snp.makeConstraints { [unowned self] make in
            make.leading.equalTo(self.cellTitleLabel1).offset(16)
            make.top.bottom.trailing.equalToSuperview().offset(16)
        }
        
        
    }

}

