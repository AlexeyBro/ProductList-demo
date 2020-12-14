//
//  ListViewController.swift
//  Redsoft
//
//  Created by Alex Bro on 11.11.2020.
//

import UIKit

protocol ListView: AnyObject {
    //refresh data in view
    func refreshView()
}

class ListViewController: UIViewController {
    
    let mainTableView = UITableView()
    let searchBarView: SearchBarView
    let viewModel: ListViewModel
    var timer: Timer?
    var isLoading = true
    let activity = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: ListViewModel, searchBarView: SearchBarView) {
        self.viewModel = viewModel
        self.searchBarView = searchBarView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        setupSearchView()
        setupTableView()
        setupConstraints()
        viewModel.loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        mainTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //table display settings
    private func setupTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.separatorStyle = .none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerReusableCell(ListTableViewCell.self)
        activity.frame = CGRect(x: 0, y: 0, width: mainTableView.bounds.width, height: 40)
        mainTableView.tableFooterView = activity
    }
    
    //searchView display settings
    private func setupSearchView() {
        view.addSubview(searchBarView)
        searchBarView.inputTextField.delegate = self
        searchBarView.listView = self
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Styles.Spaces.single),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Spaces.single),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Styles.Spaces.single),
            searchBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath) else { fatalError() }
        let product = viewModel.products[indexPath.row]
        cell.selectionStyle = .none
        cell.configurView(with: viewModel.willDisplayCell(atIndexPath: indexPath.row))
        cell.setImage(with: product.imageURL)
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if isLoading {
                loadMore()
                activity.startAnimating()
            }
        }
    }
    
    private func loadMore() {
        isLoading = false
        viewModel.loadItems()
    }
}

//MARK: - UITextFieldDelegate
extension ListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { (_) in
            guard let query = self.searchBarView.inputTextField.text else { return }
            self.viewModel.searchItems(withQuery: query)
        })
        return true
    }
}

//MARK: - ListView
extension ListViewController: ListView {
    func refreshView() {
        mainTableView.reloadData()
        activity.stopAnimating()
    }
}

//MARK: - ListCell
extension ListViewController: ListCell {
    func tapped(atIndexPath index: Int) {
        viewModel.showDetail(atIndexPath: index)
    }
}
