//
//  WebService.swift
//  NewsRxMVVM
//
//  Created by selinay ceylan on 10.03.2024.
//

import Foundation

public enum CryptoError : Error {
    case serverError
    case parsingError
}

class WebService {
    
    func download (url : URL, completion : @escaping (Result<[Crypto], CryptoError>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.serverError))
            } else if let data = data {
                let crytpoList = try? JSONDecoder().decode([Crypto].self, from: data)
                
                if let cryptoList = crytpoList {
                    completion(.success(cryptoList))
                } else {
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
}
