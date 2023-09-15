//
//  FavoriteViewController.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import UIKit
import Combine

class FavoriteViewController: NiblessViewController {
  
  //dependencies
  let viewModel: FavoriteViewModel
  
  //views
  lazy var contentView: FavoriteView? = loadNibName()
  
  var cancellable = Set<AnyCancellable>()
  
  let searchController: UISearchController = {
    let sc = UISearchController()
    sc.searchBar.placeholder = "Search Games"
    sc.obscuresBackgroundDuringPresentation = false
    return sc
  }()
  
  init(favoriteViewModel: FavoriteViewModel) {
    self.viewModel = favoriteViewModel
    super.init()
  }
  
  override func loadView() {
    super.loadView()
    
    if let favoriteView = contentView {
      view = favoriteView
      searchController.searchResultsUpdater = favoriteView
      searchController.searchBar.delegate = favoriteView
      favoriteView.searchDelegate = self
      favoriteView.deleteDelegate = self
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    observeViewModel()
    
    viewModel.fetchFavorite()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("currentVC \(String(describing: FavoriteViewController.self))")
    
    view.backgroundColor = .white
    
    navigationItem.title = "Favorite Games"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.searchController = searchController
    
  }
  
  func observeViewModel() {
    viewModel.favoriteSubject
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          break
        case .finished:
          break
        }
      } receiveValue: { [unowned self] favorites in
        self.contentView?.items = favorites
      }
      .store(in: &cancellable)
    
  }
  
}

extension FavoriteViewController: SearchDelegate {
  
  func search(_ searchText: String) {
    viewModel.searchSubject.send(searchText)
  }
  
  func searchCancelled() {
    viewModel.fetchFavorite()
  }
  
}

extension FavoriteViewController: Deletable {
  
  func onRemoved(id: Int) {
    viewModel.deleteFavorite(with: id)
  }
  
}
