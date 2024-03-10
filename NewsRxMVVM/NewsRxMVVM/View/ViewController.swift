//
//  ViewController.swift
//  NewsRxMVVM
//
//  Created by selinay ceylan on 10.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let disposeBag = DisposeBag()
    let cryptoVM = CryptoViewModel()
    var cryptoList = [Crypto]()

    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .black
        
        setupBindings()
        cryptoVM.requestData()
    }

    private func setupBindings() {
        
        cryptoVM
            .loading
            .bind(to: self.indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe (onNext: { failure in
                print(failure)
            })
            .disposed(by: disposeBag)
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe ( onNext : { crypto in
                self.cryptoList = crypto
                self.tableView.reloadData()
                print(self.cryptoList)
            }).disposed(by: disposeBag)
        
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    
   
}

