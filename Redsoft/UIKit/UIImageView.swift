//
//  UIImageView.swift
//  Redsoft
//
//  Created by Alex Bro on 06.12.2020.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
    func setImage(URLString: String) {
        guard let url = URL(string: URLString) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let response = response as? HTTPURLResponse
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data, response?.statusCode == 200 {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
