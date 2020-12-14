//
//  CacheService.swift
//  Redsoft
//
//  Created by Alex Bro on 14.12.2020.
//

import UIKit

protocol Cache {
    //put images in cache
    func putImageCache(withImage image: UIImage, forKey: URL)
    //check images in cache
    func checkImageCache(forKey key: URL) -> UIImage?
}

class CacheService: Cache {
    
    private let cache = NSCache<NSString, UIImage>()

    func putImageCache(withImage image: UIImage, forKey: URL) {
        cache.setObject(image, forKey: forKey.absoluteString as NSString)
    }

    func checkImageCache(forKey key: URL) -> UIImage? {
        let cacheImage = cache.object(forKey: key.absoluteString as NSString)
        return cacheImage
    }
}
