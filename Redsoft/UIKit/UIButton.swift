//
//  UIButton.swift
//  Redsoft
//
//  Created by Alex Bro on 14.11.2020.
//

import UIKit

extension UIButton {
    convenience init(title: String? = "",
                     image: UIImage?,
                     backgrounColor: UIColor? = .systemBlue,
                     tintColor: UIColor? = .white,
                     cornerRadius: CGFloat = Styles.CornerRadius.single) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.backgroundColor = backgrounColor
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
    }
}
