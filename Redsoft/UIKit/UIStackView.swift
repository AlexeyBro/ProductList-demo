//
//  UIStackView.swift
//  Redsoft
//
//  Created by Alex Bro on 06.12.2020.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        
        self.axis = axis
        self.spacing = spacing
    }
}
