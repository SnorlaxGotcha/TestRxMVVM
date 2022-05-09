//
//  FieldCell.swift
//  Homework
//
//  Created by 黃世維 on 2022/5/9.
//

import UIKit
import RxSwift

public class FieldCell: UITableViewCell {
    private let cellTitleLabel = UILabel()
    private let detailContainer = UIStackView()
    
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
        
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.axis  = NSLayoutConstraint.Axis.vertical
        detailContainer.distribution  = UIStackView.Distribution.equalSpacing
        detailContainer.alignment = UIStackView.Alignment.leading
        detailContainer.spacing   = 4.0
        contentView.addSubview(detailContainer)
                
        NSLayoutConstraint.activate([
            cellTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            cellTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            cellTitleLabel.bottomAnchor.constraint(equalTo: detailContainer.topAnchor, constant: -16),
            
            detailContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 56),
            detailContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailContainer.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 16),
            detailContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    
    func setViewModel(_ cellData: GetTrxDTO) {
        let date = Date(timeIntervalSince1970: TimeInterval(cellData.time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let strDate = dateFormatter.string(from: date)
        cellTitleLabel.text = "\(strDate) \(cellData.title) - \(cellData.description)"
        
        guard let details = cellData.details else { return }
        
        for detail in details {
            let label = UILabel(frame: .zero)
            label.textAlignment = .left
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let moneyString = formatter.string(from: NSNumber(value: detail.price)) ?? "$0"
            label.text = "- \(detail.name) \(moneyString) X \(detail.quantity)"
            
            self.detailContainer.addArrangedSubview(label)
        }
        
        
    }

}

