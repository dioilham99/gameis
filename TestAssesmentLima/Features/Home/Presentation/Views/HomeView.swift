//
//  HomeView.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import UIKit

protocol LoadMoreDelegate: AnyObject {
  func shouldLoadMore()
}

protocol SearchDelegate: AnyObject {
  func search(_ searchText: String)
  func searchCancelled()
}

class HomeView: UIView {
  
  @IBOutlet weak var tableView: UITableView!
  
  let adapter = HomeTableViewAdapter(items: [])
  
  weak var loadMoreDelegate: LoadMoreDelegate?
  weak var searchDelegate: SearchDelegate?
  weak var favoriteDelegate: FavoriteDelegate?
  
  private var isLoading: Bool = false
  var loadingIndicatorView: InfiniteScrollActivityView?
  
  var items: [GameViewModel] = [] {
    didSet{
      if items.isEmpty {
        let emptyView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        emptyView.backgroundColor = .red
        tableView.backgroundView = emptyView
        return
      }
      
      tableView.backgroundView = nil
      adapter.items = items
      tableView.reloadData()
      
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    adapter.scrollViewDelegate = self
    adapter.favoriteDelegate = self
    
    tableView.dataSource = adapter
    tableView.delegate = adapter
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default_cell")
    tableView.register(GameTableViewCell.nib, forCellReuseIdentifier: GameTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .onDrag
    
    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
    loadingIndicatorView = InfiniteScrollActivityView(frame: frame)
    loadingIndicatorView!.isHidden = true
    tableView.addSubview(loadingIndicatorView!)
    
    var insets = tableView.contentInset
    insets.bottom += InfiniteScrollActivityView.defaultHeight
    tableView.contentInset = insets
  }
  
  func setLoading(_ isLoading: Bool) {
    self.isLoading = isLoading
  }
  
  func stopIndicator(){
    loadingIndicatorView?.stopAnimating()
  }
  
}

extension HomeView: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    searchDelegate?.search(searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    guard let searchText = searchBar.text else { return }
//    searchDelegate?.search(searchText)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchDelegate?.searchCancelled()
  }
  
}

extension HomeView: ScrollViewDelegate {
  
  func didScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if maximumOffset - currentOffset <= 5.0 && !isLoading {
      
      let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
      loadingIndicatorView?.frame = frame
      loadingIndicatorView!.startAnimating()
      
      loadMoreDelegate?.shouldLoadMore()
    }
  }
  
  
}

extension HomeView: FavoriteDelegate {
  
  func favorite(item: GameViewModel) {
    favoriteDelegate?.favorite(item: item)
  }
  
  
  
  
}
