//
//  UILabel.swift
//  Redsoft
//
//  Created by Alex Bro on 06.12.2020.
//

import UIKit

extension UILabel {
    convenience init(text: String? = "",
                     textColor: UIColor? = .black,
                     font: UIFont? = .default14(),
                     backgroundColor: UIColor? = .white,
                     textAlignment: NSTextAlignment? = .left,
                     isWrapping: Bool = false) {
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.textAlignment = textAlignment ?? .center
        
        if isWrapping {
            self.lineBreakMode = .byWordWrapping
            self.numberOfLines = 0
        }
    }
}
