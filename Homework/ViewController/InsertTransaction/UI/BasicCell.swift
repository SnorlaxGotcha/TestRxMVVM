//
//  BasicCell.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/12.
//

import UIKit
import RxSwift

public class BasicCell: UITableViewCell {
    private let cellTitleLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setup() {
        cellTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellTitleLabel)
                
        NSLayoutConstraint.activate([
            cellTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            cellTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            cellTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    
    func setViewModel(_ cellData: String) {
        cellTitleLabel.text = cellData
    }

}

