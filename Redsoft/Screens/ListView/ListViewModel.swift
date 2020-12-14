//
//  ListViewModel.swift
//  Redsoft
//
//  Created by Alex Bro on 19.11.2020.
//

import Foundation

protocol ListViewModel: AnyObject {
    var products: [Products] { set get }
    var itemsCount: Int { get }
    //load data
    func loadItems()
    //display data in a table cell
    func willDisplayCell(atIndexPath index: Int) -> ListTableViewCellModel
    //product filter
    func searchItems(withQuery query: String)
    //go to detail screen
    func showDetail(atIndexPath index: Int)
}

class ListViewModelImpl: ListViewModel {

    weak var listView: ListView!
    var products: [Products] = []
    var itemsCount: Int { itemsPerPage() }
    private let networkService: Network!
    private let imageDownloader: DownloadImage!
    private let helper: Helper!
    private let router: Router!
    private var count = 0
    private var items = 7
    
    init(networkService: Network?, imageDownloader: DownloadImage?, helper: Helper?, router: Router?) {
        self.networkService = networkService
        self.imageDownloader = imageDownloader
        self.helper = helper
        self.router = router
    }
    
    //number of items per page
    private func itemsPerPage() -> Int {
        if count + items <= products.count {
            count += items
        } else {
            count = products.count
        }
        return count
    }
    
    func loadItems() {
        networkService.fetchData { [weak self] in
            guard let self = self else { return }
            self.products = $0?.data ?? []
            DispatchQueue.main.async {
                self.listView?.refreshView()
            }
        }
    }
    
    func searchItems(withQuery query: String) {
        networkService?.fetchSortedData(withQuery: query, completion: { [weak self] in
            guard let self = self else { return }
            self.products = $0?.data ?? []
            DispatchQueue.main.async {
                self.listView.refreshView()
            }
        })
    }
    
    func willDisplayCell(atIndexPath index: Int) -> ListTableViewCellModel {
        ListTableViewCellModelImpl(products: products[index],
                                   imageDownloader: imageDownloader,
                                   helper: helper)
    }
    
    func showDetail(atIndexPath index: Int) {
        let product = products[index]
        router.toDetailViewController(withModel: product)
    }
}
