//
//  DetailViewModel.swift
//  Redsoft
//
//  Created by Alex Bro on 29.11.2020.
//

import Foundation

protocol DetailViewModel {
    var updateData: ((Products?) -> Void)? { get set }
    //set data
    func setProducts()
    //set the initial value of the counter
    func setStartValue(forId id: Int)
    //decrease counter value
    func decreaseCount(forId id: Int)
    //increase counter value
    func increaseCount(forId id: Int)
    //get counter value
    func provideItemsCount(forId id: Int) -> Int?
}

class DetailViewModelImpl: DetailViewModel {

    var updateData: ((Products?) -> Void)?
    private var products: Products?
    private var helper: Helper?
    
    init(products: Products?, helper: Helper?) {
        self.products = products
        self.helper = helper
    }
    
    func setProducts() {
        updateData?(products)
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
