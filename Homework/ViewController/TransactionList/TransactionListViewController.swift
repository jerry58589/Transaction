//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransactionListViewController: UIViewController {

    private var viewObject: TransactionListViewObject?
    private let viewModel: TransactionListViewModel
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        return tableView
    }()
    
    private lazy var sumLabel: UILabel = {
        let sumLabel = UILabel(frame: CGRect.zero)
        sumLabel.textAlignment = .center
        sumLabel.textColor = UIColor.red
        sumLabel.text = ""
        return sumLabel
    }()
    
    private lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "addBtn"), for: .normal)
        
        addBtn.rx.tap.subscribe(onNext: {
            self.addBtnPressed(addBtn)
        }).disposed(by: disposeBag)
        
        return addBtn
    }()

    public init(viewModel: TransactionListViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    private func initView() {
        title = "Transaction List"
        self.view.backgroundColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)

        view.addSubview(tableView)
        view.addSubview(sumLabel)
        view.addSubview(addBtn)

        sumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(addBtn.snp.top).offset(-10)
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        
    }
    
    private func updateUI() {
        self.tableView.reloadData()
        self.sumLabel.text = "總價：" + (self.viewObject?.sum.priceFormat ?? "$0")
    }
    
    @objc private func loadData() {
        if AppDelegate.hasNetwork {
            viewModel.getTransactionListViewObjects().subscribe(onSuccess: { objects in
                self.viewObject = objects
                self.updateUI()
                self.refreshControl.endRefreshing()
            }, onFailure: { err in
                print(err)
            }).disposed(by: disposeBag)
        }
        else {
            self.viewModel.getDBTransactionListViewObject().subscribe(onSuccess: { objects in
                self.viewObject = objects
                self.updateUI()
                self.refreshControl.endRefreshing()
            }, onFailure: { err in
                print(err)
            }).disposed(by: self.disposeBag)
        }
        
    }
    
    private func deleteBtnPressed(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "是否要刪除", message: "是否要刪除?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是的", style: .default) { _ in
            
            if AppDelegate.hasNetwork {
                self.viewModel.deleteTransactionViewObject(id: sender.tag).subscribe(onSuccess: { objects in
                    self.viewObject = objects
                    self.updateUI()
                }, onFailure: { err in
                    print(err)
                }).disposed(by: self.disposeBag)
            }
            else {
                self.viewModel.deleteDBTransactionViewObject(id: sender.tag).subscribe(onSuccess: { objects in
                    self.viewObject = objects
                    self.updateUI()
                }, onFailure: { err in
                    print(err)
                }).disposed(by: self.disposeBag)
            }
        }
        
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func addBtnPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(InsertTransactionViewController(), animated: true)
    }

}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = self.viewObject?.sections.count ?? 0
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = self.viewObject?.sections[section].cells.count ?? 0
        return cellCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #warning("DOTO: TransactionListDetailTableViewCell OK")
        
        let reuseIdentifier = "\(indexPath.section)-\(indexPath.row)"
        let cell = TransactionListDetailTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        let cellViewObject = self.viewObject?.sections[indexPath.section].cells[indexPath.row] ?? TransactionListCellViewObject(name: "cellViewObject error", priceWithQuantity: "$")
        cell.updateView(cellViewObject)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        #warning("DOTO: TransactionListSectionView OK")
        
        let sectionViewObject = self.viewObject?.sections[section] ?? TransactionListSectionViewObject(title: "sectionViewObject error", time: "1970/01/01", id: 0, cells: [])
        let headerView = TransactionListSectionView(frame: CGRect.zero, transactionListItemViewObject: sectionViewObject)
        
        headerView.deleteBtn.rx.tap.subscribe(onNext: {
            self.deleteBtnPressed(headerView.deleteBtn)
        }).disposed(by: disposeBag)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionDetailViewController()
        
        if let id = viewObject?.sections[indexPath.section].id {
            vc.viewObject = viewModel.genTransactionDetailViewObject(id: id)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


