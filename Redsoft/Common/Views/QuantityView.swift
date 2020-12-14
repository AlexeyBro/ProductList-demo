//
//  QuantityView.swift
//  Redsoft
//
//  Created by Alex Bro on 13.11.2020.
//

import UIKit

protocol QuantityViewDelegat: AnyObject {
    //set the initial value of the counter
    func setStartValue(forId id: Int)
    //increase counter value
    func increaseCount(forId id: Int)
    //decrease counter value
    func decreaseCount(forId id: Int)
    //get counter value
    func provideItemsCount(forId id: Int) -> Int?
}

//button display selection
enum BasketButtonStyle {
    case small
    case large
}

class QuantityView: UIView {

    weak var delegat: QuantityViewDelegat?
    var id: Int?
    let bgView = UIView()
    var basketButton = UIButton()
    let quantityLabel = UILabel(textColor: .white,
                                backgroundColor: .systemBlue,
                                textAlignment: .center)
    private let plusButton = UIButton(image: UIImage(systemName: "plus"))
    private let minusButton = UIButton(image: UIImage(systemName: "minus"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBgView()
        setupConstraints()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonStyle: BasketButtonStyle) {
        self.init()
        switch buttonStyle {
        case .small:
            basketButton = smallButtonStyle()
        case .large:
            basketButton = largeButtonStyle()
        }
    }
    
    //create a label title
    private func makeTitle() -> String {
        guard let id = id else { return "" }
        guard let count = delegat?.provideItemsCount(forId: id) else { return "" }
        return "\(String(describing: count)) шт"
    }
    
    func startState() {
        guard let id = id else { return }
        guard let count = delegat?.provideItemsCount(forId: id) else { return }
        if count >= 1 {
            basketButton.isHidden = true
            bgView.isHidden = false
            quantityLabel.text = makeTitle()
        }
    }
    
    //increase and decrease button settings
    private func setupButtons() {
        minusButton.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
    }
    
    @objc func basketButtonAction() {
        guard let id = id else { return }
        delegat?.setStartValue(forId: id)
        startState()
    }
    
    @objc func minusButtonAction() {
        guard let id = id else { return }
        guard let count = delegat?.provideItemsCount(forId: id) else { return }
        delegat?.decreaseCount(forId: id)
        quantityLabel.text = makeTitle()
        if count < 2 {
            basketButton.isHidden = false
            bgView.isHidden = true
        }
    }
    
    @objc func plusButtonAction() {
        guard let id = id else { return }
        delegat?.increaseCount(forId: id)
        quantityLabel.text = makeTitle()
    }
    
    //background settings
    private func setupBgView() {
        bgView.backgroundColor = .systemBlue
        bgView.layer.cornerRadius = Styles.CornerRadius.single
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.isHidden = true
        self.addSubview(bgView)
    }
    
    private func smallButtonStyle() -> UIButton {
        let smallButton = UIButton(image: UIImage(systemName: "cart"),
                                           backgrounColor: .white,
                                           tintColor: .systemBlue)
        smallButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(smallButton)
        smallButton.addTarget(self, action: #selector(basketButtonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            smallButton.widthAnchor.constraint(equalToConstant: 25),
            smallButton.heightAnchor.constraint(equalToConstant: 25),
            smallButton.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            smallButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor)
        ])
        return smallButton
    }
    
    private func largeButtonStyle() -> UIButton {
        let largeButton = UIButton(title: "В корзину",
                                   image: nil,
                                   backgrounColor: .systemBlue,
                                   tintColor: .white)
        largeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(largeButton)
        largeButton.addTarget(self, action: #selector(basketButtonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            largeButton.topAnchor.constraint(equalTo: bgView.topAnchor),
            largeButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            largeButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            largeButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
        ])
        return largeButton
    }
    
    private func setupConstraints() {
        [minusButton, quantityLabel, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minusButton.heightAnchor.constraint(equalToConstant: 25),
            minusButton.widthAnchor.constraint(equalToConstant: 25),
            minusButton.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            
            quantityLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            plusButton.heightAnchor.constraint(equalToConstant: 25),
            plusButton.widthAnchor.constraint(equalToConstant: 25),
            plusButton.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor)
        ])
    }
}
