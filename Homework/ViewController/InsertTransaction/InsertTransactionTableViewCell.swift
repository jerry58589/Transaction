//
//  InsertTransactionTableViewCell.swift
//  Homework
//
//  Created by JerryLo on 2022/3/14.
//

import UIKit

class InsertTransactionTableViewCell: UITableViewCell {
    
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
        return backView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.text = "Name = "
        return label
    }()

    private lazy var quantityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.text = "Quantity = "
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.text = "Price = "
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Name"
        textField.accessibilityIdentifier = TextFieldIdentifier.name.rawValue
//        textField.setTextFieldUI()
        return textField
    }()
    
    lazy var quantityTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Quantity"
        textField.accessibilityIdentifier = TextFieldIdentifier.quantity.rawValue
        textField.keyboardType = .numberPad
//        textField.setTextFieldUI()
        return textField
    }()
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "Price"
        textField.accessibilityIdentifier = TextFieldIdentifier.price.rawValue
        textField.keyboardType = .numberPad
//        textField.setTextFieldUI()
        return textField
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "deleteBtn"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(quantityLabel)
        backView.addSubview(priceLabel)
        backView.addSubview(nameTextField)
        backView.addSubview(quantityTextField)
        backView.addSubview(priceTextField)
        backView.addSubview(deleteBtn)

        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(44)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
        }

        quantityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(nameLabel.snp.width)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(quantityLabel.snp.bottom).offset(20)
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(nameLabel.snp.width)
        }

        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right)
            make.right.equalTo(deleteBtn.snp.left)
            make.centerY.equalTo(nameLabel)
        }
        
        quantityTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTextField)
            make.centerY.equalTo(quantityLabel)
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTextField)
            make.centerY.equalTo(priceLabel)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTag(row: Int) {
        deleteBtn.tag = row
        nameTextField.tag = row
        quantityTextField.tag = row
        priceTextField.tag = row
    }
    
    func setUserEnabled(_ isEdit: Bool) {
        if isEdit {
            nameTextField.setTextFieldUI()
            quantityTextField.setTextFieldUI()
            priceTextField.setTextFieldUI()
        }
        
        nameTextField.isUserInteractionEnabled = isEdit
        quantityTextField.isUserInteractionEnabled = isEdit
        priceTextField.isUserInteractionEnabled = isEdit
    }
    
    func updateView(_ viewOject: InsertTransactionCellViewObject?) {
        nameTextField.text = viewOject?.name ?? ""
        quantityTextField.text = viewOject?.quantity ?? ""
        priceTextField.text = viewOject?.price ?? ""
    }


}

