//
//  HomeTableViewAdapter.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 13/02/23.
//

import Foundation
import UIKit

class HomeTableViewAdapter: GameTableViewAdapter {

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let item = items[indexPath.row]
    let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [unowned self] action, view, completionHandler in
      favoriteDelegate?.favorite(item: item)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    favoriteAction.backgroundColor = .orange
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
    
    return swipeConfiguration
  }
  
}
