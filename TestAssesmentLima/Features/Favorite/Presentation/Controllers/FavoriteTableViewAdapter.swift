//
//  FavoriteTableViewAdapter.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation
import UIKit

protocol Deletable: AnyObject {
  func onRemoved(id: Int)
}

class FavoriteTableViewAdapter: GameTableViewAdapter {
  
  weak var deleteDelegate: Deletable?
  
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      deleteDelegate?.onRemoved(id: items[indexPath.row].id)
      items.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
}
