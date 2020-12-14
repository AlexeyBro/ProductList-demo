//
//  ListTableViewCell.swift
//  Redsoft
//
//  Created by Alex Bro on 11.11.2020.
//

import UIKit

protocol ListCell: AnyObject {
    //tap on the cell
    func tapped(atIndexPath index: Int)
}

class ListTableViewCell: UITableViewCell {
    
    var viewModel: ListTableViewCellModel?
    weak var delegate: ListCell?
    var index: Int?
    private let bgView = UIView()
    private var stackView = UIStackView()
    private let cellImage = UIImageView(image: #imageLiteral(resourceName: "22-200x300"), contentMode: .scaleAspectFill)
    private let categoryLabel = UILabel(textColor: .lightGray, font: .default14())
    private let productLabel = UILabel(font: .defaultBold20())
    private let producerLabel = UILabel(textColor: .lightGray, font: .defaultBold16())
    private let priceLabel = UILabel(textColor: .systemBlue, font: .defaultBold20())
    private var quantityView = QuantityView(buttonStyle: .small)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupBackgroundView()
        setupStackView()
        setupConstraints()
        tapSettings()
        quantityView.delegat = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        quantityView.startState()
        if cellImage.image == nil {
            cellImage.image = #imageLiteral(resourceName: "22-200x300")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
        quantityView.basketButton.isHidden = false
        quantityView.bgView.isHidden = true
        quantityView.quantityLabel.text = nil
    }
    
    func configurView(with model: ListTableViewCellModel) {
        viewModel = model
        categoryLabel.text = model.category?.first?.title
        productLabel.text = model.title
        producerLabel.text = model.producer
        priceLabel.text = model.price
        quantityView.id = model.id
    }
    
    func setImage(with urlString: String) {
        viewModel?.fetchImage(withUrl: urlString, completion: { [weak self] in
            guard let self = self else { return }
            self.cellImage.image = $0
        })
    }
    
    //gesture recognizer settings
    private func tapSettings() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        cellImage.addGestureRecognizer(imageTap)
        cellImage.isUserInteractionEnabled = true
        productLabel.addGestureRecognizer(labelTap)
        productLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapped() {
        guard let index = index else { return }
        delegate?.tapped(atIndexPath: index)
    }
    
    private func setupBackgroundView() {
        contentView.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = Styles.CornerRadius.single
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 1
    }
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [categoryLabel, productLabel, producerLabel],
                                    axis: .vertical,
                                    spacing: 5.0)
    }
    
    private func setupConstraints() {
        [cellImage, stackView, priceLabel,
         quantityView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview($0)
         }
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Styles.Spaces.single),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Styles.Spaces.single),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Styles.Spaces.single),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: bgView.topAnchor, constant: Styles.Spaces.single),
            cellImage.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: Styles.Spaces.single),
            cellImage.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -Styles.Spaces.single),
            cellImage.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            cellImage.widthAnchor.constraint(equalToConstant: 100),
            cellImage.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: Styles.Spaces.single),
            stackView.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: Styles.Spaces.double),
            
            priceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Styles.Spaces.single),
            priceLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: Styles.Spaces.double),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Styles.Spaces.single),
            priceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            quantityView.widthAnchor.constraint(equalToConstant: 100),
            quantityView.heightAnchor.constraint(equalToConstant: 25),
            quantityView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            quantityView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -Styles.Spaces.double)
        ])
    }
}

//MARK: - QuantityViewDelegat
extension ListTableViewCell: QuantityViewDelegat {
    func setStartValue(forId id: Int) {
        viewModel?.setStartValue(forId: id)
    }
    
    func increaseCount(forId index: Int) {
        viewModel?.increaseCount(forId: index)
    }
    
    func decreaseCount(forId index: Int) {
        viewModel?.decreaseCount(forId: index)
    }
    
    func provideItemsCount(forId index: Int) -> Int? {
        viewModel?.provideItemsCount(forId: index)
    }
}
