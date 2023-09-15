//
//  FavoriteView.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation
import UIKit

class FavoriteView: UIView {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy var emptyView: EmptyView? = loadNibName()
  
  weak var searchDelegate: SearchDelegate?
  weak var deleteDelegate: Deletable?
  
  private var isLoading: Bool = false
  
  let adapter = FavoriteTableViewAdapter(items: [])
  
  var items: [GameViewModel] = [] {
    didSet{
      if items.isEmpty {
        tableView.backgroundView = emptyView
        adapter.items = items
        tableView.reloadData()
        return
      }
      
      tableView.backgroundView = nil
      adapter.items = items
      tableView.reloadData()
      
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    adapter.deleteDelegate = self
    tableView.dataSource = adapter
    tableView.delegate = adapter
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default_cell")
    tableView.register(GameTableViewCell.nib, forCellReuseIdentifier: GameTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
  }
  
  func setLoading(_ isLoading: Bool) {
    self.isLoading = isLoading
  }
  
}

extension FavoriteView: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    searchDelegate?.search(searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchDelegate?.searchCancelled()
  }
  
}

extension FavoriteView: Deletable {
  
  func onRemoved(id: Int) {
    deleteDelegate?.onRemoved(id: id)
  }
  
}
