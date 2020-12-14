//
//  UITableView+Cell.swift
//  Redsoft
//
//  Created by Alex Bro on 06.12.2020.
//

import UIKit

extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.description())
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: cellType.description(), for: indexPath) as? T
    }
}
