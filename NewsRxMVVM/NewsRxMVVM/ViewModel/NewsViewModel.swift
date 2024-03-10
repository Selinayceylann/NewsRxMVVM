//
//  NewsViewModel.swift
//  NewsRxMVVM
//
//  Created by selinay ceylan on 10.03.2024.
//

import Foundation
import RxSwift
import RxCocoa

class CryptoViewModel {
    
    public let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<String> = PublishSubject()
    
    func requestData() {
        
        self.loading.onNext(true)
        WebService().download(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!) { cryptoResult in
            self.loading.onNext(false)
            switch cryptoResult {
            case .success(let cryptos):
                print(cryptos)
                self.cryptos.onNext(cryptos)
            case .failure(let failure):
                switch failure {
                case .parsingError:
                    self.error.onNext("Parse!!")
                case .serverError:
                    self.error.onNext("Server!!")
                    
                }
            }
        }
    }
}
