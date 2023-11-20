//
//  CharacterDetailsDataSource.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit

public final class CharacterDetailsDataSource: NSObject {
    private unowned var tableView: UITableView
   //private var data: UserModel?
    let titlesArray = ["Gender", "Status", "Specie", "Origin", "Type", "Location"]
    
    // MARK: - Init
    
    public init(
        tableView: UITableView
    ) {
        self.tableView = tableView
        super.init()
        
        self.tableView.dataSource = self
    }
    
//    func reload(_ model: UserModel) {
//        self.data = model
//        self.tableView.reloadData()
//    }
}

// MARK: - UITableViewDataSource

extension CharacterDetailsDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titlesArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(cell: CharacterDetailsTableViewCell.self, for: indexPath)
        cell.configure(title: "\(titlesArray[indexPath.row])",
                       description: "bb")
        
        return cell
    }
}
