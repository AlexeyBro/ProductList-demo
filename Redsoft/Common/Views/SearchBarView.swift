//
//  SearchBarView.swift
//  Redsoft
//
//  Created by Alex Bro on 15.11.2020.
//

import UIKit

class SearchBarView: UIView {
    
    let inputTextField = UITextField()
    weak var listView: ListView!
    private weak var viewModel: ListViewModel!
    private let resetButton = UIButton(image: UIImage(systemName: "arrow.left"),
                                      backgrounColor: .white,
                                      tintColor: .gray)
    private let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"),
                                         contentMode: .scaleAspectFill)
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        self.backgroundColor = .white
        self.layer.cornerRadius = Styles.CornerRadius.single
        setupButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //reset button settings
    private func setupButton() {
        resetButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    }
    
    @objc func clearText() {
        inputTextField.text = nil
        viewModel.loadItems()
    }
    
    private func setupView() {
        [inputTextField, resetButton, searchIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        inputTextField.placeholder = "Я ищу"
        inputTextField.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 25),
            resetButton.heightAnchor.constraint(equalToConstant: 25),
            resetButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Styles.Spaces.single),
            resetButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
            
            inputTextField.topAnchor.constraint(equalTo: self.topAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: Styles.Spaces.single),
            inputTextField.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -Styles.Spaces.single),
            inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            searchIcon.widthAnchor.constraint(equalToConstant: 25),
            searchIcon.heightAnchor.constraint(equalToConstant: 25),
            searchIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Styles.Spaces.single),
            searchIcon.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor)
        ])
    }
}
