//
//  AssemblyService.swift
//  Redsoft
//
//  Created by Alex Bro on 08.12.2020.
//

import UIKit

enum Modules {
    case list
    case detail
}

protocol Assembly {
    func makeModule(module: Modules, products: Products?, router: Router?) -> UIViewController
}

class AssemblyService: Assembly {
    
    let networkService = NetworkService()
    let cacheService = CacheService()
    let helper = HelperService()
    
    func makeModule(module: Modules, products: Products?, router: Router?) -> UIViewController {
        switch module {
        case .list:
            return makeListViewController(router: router)
        case .detail:
            return makeDetailViewController(products: products, router: router)
        }
    }
    
    func makeListViewController(router: Router?) -> UIViewController {
        let imageDownloader = ImageDownloader(cacheService: cacheService)
        let viewModel = ListViewModelImpl(networkService: networkService, imageDownloader: imageDownloader, helper: helper, router: router)
        let searchBar = SearchBarView(viewModel: viewModel)
        let listViewController = ListViewController(viewModel: viewModel, searchBarView: searchBar)
        viewModel.listView = listViewController
        return listViewController
    }
    
    func makeDetailViewController(products: Products?, router: Router?) -> UIViewController {
        let viewModel = DetailViewModelImpl(products: products, helper: helper)
        let detailViewController = DetailViewController(viewModel: viewModel)
        return detailViewController
    }
}
