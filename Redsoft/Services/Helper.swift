//
//  HelperService.swift
//  Redsoft
//
//  Created by Alex Bro on 28.11.2020.
//

import Foundation

enum Options {
    case startValue
    case minus
    case plus
}

protocol Helper {
    func provideItemsCount(forId id: Int) -> Int?
    func changeCount(forId id: Int, options: Options)
}

class HelperService: Helper {
    
    private var countDict = [Int: Int]()
    
    func provideItemsCount(forId id: Int) -> Int? {
        countDict[id]
    }
    
    func changeCount(forId id: Int, options: Options) {
        guard let value = countDict[id] else {
            countDict[id] = 1
            return
        }
        
        switch options {
        case .startValue:
            countDict[id] = 1
        case .plus:
            countDict[id] = value + 1
        case .minus:
            countDict[id] = value - 1
        }
    }
}
