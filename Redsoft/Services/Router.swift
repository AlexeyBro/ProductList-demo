//
//  RouterService.swift
//  Redsoft
//
//  Created by Alex Bro on 08.12.2020.
//

import UIKit

protocol Router {
    func initialViewController()
    func toDetailViewController(withModel products: Products?)
}

class RouterService: Router {
    private var navigationController: UINavigationController?
    private var assembly: Assembly?
    
    init(navigationController: UINavigationController, assembly: Assembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let listViewController = assembly?.makeModule(module: .list, products: nil, router: self) else { return }
            navigationController.viewControllers = [listViewController]
        }
    }
    
    func toDetailViewController(withModel products: Products?) {
        if let navigationController = navigationController {
            guard let detailViewController = assembly?.makeModule(module: .detail, products: products, router: nil) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}
