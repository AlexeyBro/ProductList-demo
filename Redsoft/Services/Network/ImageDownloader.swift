//
//  ImageDownloader.swift
//  Redsoft
//
//  Created by Alex Bro on 14.12.2020.
//

import UIKit

protocol DownloadImage {
    //get images
    func fetchImage(withUrl urlString: String, completion: @escaping (UIImage?) -> Void)
}

class ImageDownloader: DownloadImage {
    
    private let cacheService: Cache?
    
    init(cacheService: Cache?) {
        self.cacheService = cacheService
    }
    
    func fetchImage(withUrl urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        if let cacheImage = cacheService?.checkImageCache(forKey: url) {
            DispatchQueue.main.async {
                completion(cacheImage)
            }
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            URLSession.shared.dataTask(with: request) { data, response, error in
                let response = response as? HTTPURLResponse
                if let error = error {
                    print(error.localizedDescription)
                }
                if response?.statusCode == 200,
                   let data = data {
                    guard let image = UIImage(data: data) else { return }
                    self.cacheService?.putImageCache(withImage: image, forKey: url)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }.resume()
        }
    }
}
