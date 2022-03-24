//
//  InsertTransactionViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import RxSwift
import RxCocoa

class InsertTransactionViewController: UIViewController {

    #warning("DOTO: Insert Transaction OK")
    
    private var viewObject = InsertTransactionViewObject()
    private let viewModel: InsertTransactionViewModel
    private let disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "title ="
        return label
    }()
    
    private lazy var desLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "description ="
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "time ="
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "title"
        textField.accessibilityIdentifier = TextFieldIdentifier.title.rawValue
        textField.delegate = self
        textField.setTextFieldUI()
        return textField
    }()
    
    private lazy var desTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "description"
        textField.accessibilityIdentifier = TextFieldIdentifier.description.rawValue
        textField.delegate = self
        textField.setTextFieldUI()
        return textField
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.placeholder = "date"
        textField.accessibilityIdentifier = TextFieldIdentifier.time.rawValue
        textField.inputView = datePicker
        textField.delegate = self
        textField.setTextFieldUI()
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    private lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "addBtn"), for: .normal)
        addBtn.rx.tap.subscribe(onNext: {
            self.addBtnPressed(addBtn)
        }).disposed(by: disposeBag)
        
        return addBtn
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.calendar = Calendar(identifier: .republicOfChina)
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(pickerAction(_:)), for: .valueChanged)


        return datePicker
    }()

    private lazy var doneBtn: UIBarButtonItem = {
        let doneBtn = UIBarButtonItem()
        doneBtn.title = "Done"
        doneBtn.style = .done
        
        doneBtn.rx.tap.subscribe(onNext: {
            self.donePressed()
        }).disposed(by: disposeBag)

        return doneBtn
    }()
    
    public init(viewModel: InsertTransactionViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        initView()
    }
    
    private func initData() {
        viewObject = InsertTransactionViewObject(title: "", description: "", time: "", details: [InsertTransactionCellViewObject(name: "", price: "", quantity: "")])
    }
    
    private func initView() {
        title = "Insert Transaction"
        self.navigationItem.rightBarButtonItem = doneBtn
        self.view.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { (tap) in
            self.dismissKeyboard()
        })
        .disposed(by: disposeBag)

        self.view.addGestureRecognizer(tap)

        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(desLabel)
        view.addSubview(desTextField)
        view.addSubview(timeLabel)
        view.addSubview(timeTextField)
        view.addSubview(tableView)
        view.addSubview(addBtn)

        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(110)
            make.left.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(120)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(titleLabel.snp.width)
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(titleLabel.snp.width)
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(desLabel.snp.bottom).offset(20)
        }
        
        titleTextField.snp.makeConstraints { (make) in
            make.height.equalTo(titleLabel.snp.height)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().inset(30)
            make.centerY.equalTo(titleLabel)
        }
        
        desTextField.snp.makeConstraints { (make) in
            make.height.equalTo(titleLabel.snp.height)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(titleTextField.snp.right)
            make.centerY.equalTo(desLabel)
        }
        
        timeTextField.snp.makeConstraints { (make) in
            make.height.equalTo(titleLabel.snp.height)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(titleTextField.snp.right)
            make.centerY.equalTo(timeLabel)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(addBtn.snp.top).offset(-10)
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func donePressed() {
        viewModel.addTransactionViewObject(viewObject: viewObject).subscribe(onSuccess: { [weak self] status in
            
            if status == .success {
                self?.navigationController?.popViewController(animated: true)
            }
        }, onFailure: { err in
            print(err)
            
        }).disposed(by: self.disposeBag)
    }
    
    private func addBtnPressed(_ sender: UIButton) {
        viewObject.details.append(InsertTransactionCellViewObject(name: "", price: "", quantity: ""))
        tableView.reloadData()
    }
    
    private func deleteBtnPressed(_ sender: UIButton) {
        viewObject.details.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc private func pickerAction(_ sender: UIDatePicker) {
        timeTextField.text = Int(sender.date.timeIntervalSince1970).timestampDateStr
        viewObject.time = timeTextField.text ?? ""
    }

    
}

extension InsertTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewObject.details.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "\(indexPath.row)"
        let cell = InsertTransactionTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.selectionStyle = .none
        cell.deleteBtn.rx.tap.subscribe(onNext: {
            self.deleteBtnPressed(cell.deleteBtn)
        }).disposed(by: disposeBag)
        
        cell.updateView((viewObject.details[indexPath.row]))
        cell.setTag(row: indexPath.row)
        cell.nameTextField.delegate = self
        cell.quantityTextField.delegate = self
        cell.priceTextField.delegate = self
        cell.setUserEnabled(true)

        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    
}

extension InsertTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.accessibilityIdentifier == TextFieldIdentifier.time.rawValue {
            textField.text = Int(datePicker.date.timeIntervalSince1970).timestampDateStr
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.accessibilityIdentifier {
        case TextFieldIdentifier.title.rawValue:
            viewObject.title = textField.text ?? ""
            break
        case TextFieldIdentifier.description.rawValue:
            viewObject.description = textField.text ?? ""
            break
        case TextFieldIdentifier.time.rawValue:
            viewObject.time = textField.text ?? ""
            break
        case TextFieldIdentifier.name.rawValue:
            viewObject.details[textField.tag].name = textField.text ?? ""
            break
        case TextFieldIdentifier.quantity.rawValue:
            viewObject.details[textField.tag].quantity = textField.text ?? ""
            break
        case TextFieldIdentifier.price.rawValue:
            viewObject.details[textField.tag].price = textField.text ?? ""
            break
        default:
            break
        }
    }
    
    
}

