//
//  TransactionListSectionView.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit

class TransactionListSectionView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "deleteBtn"), for: .normal)
        return btn
    }()

    init(frame: CGRect, transactionListItemViewObject:TransactionListSectionViewObject) {
        super.init(frame: frame)

        titleLabel.text = transactionListItemViewObject.title
        timeLabel.text = transactionListItemViewObject.time
        deleteBtn.tag = transactionListItemViewObject.id

        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(deleteBtn)

        backgroundColor = UIColor.black

        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(deleteBtn.snp.left).offset(-8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
