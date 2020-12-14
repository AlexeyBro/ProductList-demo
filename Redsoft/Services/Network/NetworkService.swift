//
//  NetworkService.swift
//  Redsoft
//
//  Created by Alex Bro on 17.11.2020.
//

import UIKit

protocol Network {
    //to get data
    func fetchData(complition: @escaping (ProductsModel?) -> Void)
    //filter data
    func fetchSortedData(withQuery query: String, completion: @escaping (ProductsModel?) -> Void)
}

class NetworkService: Network {
    
    private let url = URL(string: Constant.host + Constant.body)
    
    private enum Decoder {
        static func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(type, from: data)
                return value
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
            return nil
        }
    }
    
    func fetchData(complition: @escaping (ProductsModel?) -> Void) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                DispatchQueue.main.async {
                    complition(Decoder.decode(type: ProductsModel.self, data: data))
                }
            }
        }.resume()
    }
    
    func fetchSortedData(withQuery query: String, completion: @escaping (ProductsModel?) -> Void) {
        let urlTitle = URL(string: Constant.host + Constant.body + Constant.filter + query)
        guard let url = urlTitle else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion(Decoder.decode(type: ProductsModel.self, data: data))
                }
            }
        }.resume()
    }
}

private enum Constant {
    static let host = "https://"
    static let body = "rstestapi.redsoftdigital.com/api/v1/products"
    static let filter = "?filter[title]="
}
