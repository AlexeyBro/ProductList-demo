//
//  DetailViewController.swift
//  Redsoft
//
//  Created by Alex Bro on 12.11.2020.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel?
    private var stackView = UIStackView()
    private var categoryLabels = [UILabel]()
    private let titleLabel = UILabel(font: .defaultBold20())
    private let producerLabel = UILabel(textColor: .lightGray, font: .defaultBold16())
    private let descriptionLabel = UILabel(font: .default14(), isWrapping: true)
    private let detailImage = UIImageView(image: #imageLiteral(resourceName: "22-200x300"), contentMode: .scaleAspectFill)
    private let priceLabel = UILabel(textColor: .systemBlue, font: .defaultBold20())
    private let quantityView = QuantityView(buttonStyle: .large)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        comfigurView()
        viewModel?.setProducts()
        setupView()
        quantityView.delegat = self
        quantityView.startState()
    }
    
    //display a list of categories
    private func makeCategoryLabel(withTitle title: [Category]?) {
        title?.forEach {
            let label = UILabel(textColor: .lightGray, font: .default14())
            label.text = $0.title
            self.categoryLabels.append(label)
        }
    }
    
    //update data for outlets
    private func comfigurView() {
        viewModel?.updateData = { [weak self] in
            guard let self = self else { return }
            self.detailImage.setImage(URLString: $0?.imageURL ?? "")
            self.titleLabel.text = $0?.title
            self.producerLabel.text = $0?.producer
            self.descriptionLabel.text = $0?.shortDescription
            self.priceLabel.text = String($0?.price ?? 0)
            self.makeCategoryLabel(withTitle: $0?.categories)
            self.navigationController?.navigationBar.topItem?.title = $0?.title
            self.quantityView.id = $0?.id
        }
    }
    
    private func setupView() {
        stackView = UIStackView(arrangedSubviews: categoryLabels,
                                    axis: .vertical,
                                    spacing: 5)
        
        [titleLabel, producerLabel,
         detailImage, descriptionLabel,
         stackView, priceLabel, quantityView].forEach({ view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Styles.Spaces.single),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Spaces.single),
            
            producerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Styles.Spaces.single),
            producerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Spaces.single),
            
            detailImage.topAnchor.constraint(equalTo: producerLabel.bottomAnchor, constant: Styles.Spaces.double),
            detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Spaces.single),
            
            descriptionLabel.topAnchor.constraint(equalTo: detailImage.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: detailImage.trailingAnchor, constant: Styles.Spaces.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Styles.Spaces.single),
            
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Styles.Spaces.double),
            stackView.leadingAnchor.constraint(equalTo: detailImage.trailingAnchor, constant: Styles.Spaces.double),
            
            priceLabel.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: Styles.Spaces.marginEdge40),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Spaces.single),
            
            quantityView.widthAnchor.constraint(equalToConstant: 120),
            quantityView.heightAnchor.constraint(equalToConstant: 30),
            quantityView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            quantityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Styles.Spaces.single)
        ])
    }
}

//MARK: - QuantityViewDelegat
extension DetailViewController: QuantityViewDelegat {
    func setStartValue(forId id: Int) {
        viewModel?.setStartValue(forId: id)
    }
    
    func increaseCount(forId id: Int) {
        viewModel?.increaseCount(forId: id)
    }
    
    func decreaseCount(forId id: Int) {
        viewModel?.decreaseCount(forId: id)
    }
    
    func provideItemsCount(forId id: Int) -> Int? {
        viewModel?.provideItemsCount(forId: id)
    }
}
