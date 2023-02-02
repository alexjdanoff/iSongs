//
//  UITableView+Extension.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

public extension UITableView {
    func addTableHeaderViewLine() {
        self.tableHeaderView = {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1 / UIScreen.main.scale))
            line.backgroundColor = self.separatorColor
            return line
        }()
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        register(cellType, forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
