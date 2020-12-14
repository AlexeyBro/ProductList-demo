//
//  ListTableViewCellModel.swift
//  Redsoft
//
//  Created by Alex Bro on 19.11.2020.
//

import UIKit

protocol ListTableViewCellModel {
    var category: [Category]? { get }
    var title: String? { get }
    var producer: String? { get }
    var price: String? { get }
    var id: Int? { get }
    //get image for cell
    func fetchImage(withUrl urlString: String, completion: @escaping (UIImage?) -> Void)
    //get counter value
    func provideItemsCount(forId id: Int) -> Int?
    //decrease counter value
    func decreaseCount(forId id: Int)
    //increase counter value
    func increaseCount(forId id: Int)
    //set the initial value of the counter
    func setStartValue(forId id: Int)
}

class ListTableViewCellModelImpl: ListTableViewCellModel {
    
    var category: [Category]? { products?.categories }
    var title: String? { products?.title }
    var producer: String? { products?.producer }
    var price: String? { String(products?.price ?? 0) }
    var id: Int? { products?.id }
    private var products: Products?
    private var imageDownloader: DownloadImage?
    private var helper: Helper?
    
    init(products: Products?, imageDownloader: DownloadImage?, helper: Helper?) {
        self.products = products
        self.imageDownloader = imageDownloader
        self.helper = helper
    }
    
    func fetchImage(withUrl urlString: String, completion: @escaping (UIImage?) -> Void) {
        imageDownloader?.fetchImage(withUrl: urlString, completion: {
            completion($0)
        })
    }
    
    func provideItemsCount(forId id: Int) -> Int? {
        helper?.provideItemsCount(forId: id)
    }
    
    func decreaseCount(forId id: Int) {
        helper?.changeCount(forId: id, options: .minus)
    }
    
    func increaseCount(forId id: Int) {
        helper?.changeCount(forId: id, options: .plus)
    }
    
    func setStartValue(forId id: Int) {
        helper?.changeCount(forId: id, options: .startValue)
    }
}
