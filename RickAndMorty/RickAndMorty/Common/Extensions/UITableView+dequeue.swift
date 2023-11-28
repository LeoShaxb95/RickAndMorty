//
//  UITableView+dequeue.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit

public extension UITableView {
    
    func dequeue<T: AnyObject>(
        cell cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withIdentifier: String(describing: cellType),
            for: indexPath
        ) as! T
    }
}
