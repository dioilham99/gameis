//
//  HomeViewController.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import UIKit
import Combine

class HomeViewController: NiblessViewController {
  
  //dependecies
  let viewModel: HomeViewModel
  
  lazy var contentView: HomeView? = loadNibName()
  
  private var cancellable = Set<AnyCancellable>()
  
  let searchController: UISearchController = {
    let sc = UISearchController()
    sc.searchBar.placeholder = "Search Games"
    sc.obscuresBackgroundDuringPresentation = false
    return sc
  }()
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  override func loadView() {
    super.loadView()
    
    if let homeView = contentView {
      view = homeView
      searchController.searchResultsUpdater = homeView
      searchController.searchBar.delegate = homeView
      homeView.loadMoreDelegate = self
      homeView.searchDelegate = self
      homeView.favoriteDelegate = self
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("currentVC \(String(describing: HomeViewController.self))")
    
    view.backgroundColor = .white
    
    navigationItem.title = "Games For You"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.searchController = searchController
    
    observeViewModel()
    
    fetch()
  }
  
  func observeViewModel(){
    
    viewModel.loadingSubject
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: {
        $0
        ? self.displayAnimatedActivityIndicatorView()
        : self.hideAnimatedActivityIndicatorView()
      })
      .store(in: &cancellable)
    
    viewModel.gameSubject
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure:
          self?.contentView?.items = []
        case .finished:
          break
        }
      } receiveValue: { [weak self] games in
        self?.contentView?.setLoading(false)
        self?.contentView?.items = games
      }
      .store(in: &cancellable)
    
    viewModel.errorSubject
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] msg in
        self.contentView?.stopIndicator()
        self.showAlert(alertText: "Warning", alertMessage: msg)
      }
      .store(in: &cancellable)
    
    viewModel.messageSubject
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] msg in
        self.showAlert(alertText: "Success", alertMessage: msg)
      }
      .store(in: &cancellable)
  }
  
  fileprivate func fetch(){
    contentView?.setLoading(true)
    viewModel.fetchGame()
  }
  
}

extension HomeViewController: LoadMoreDelegate {
  
  func shouldLoadMore() {
    contentView?.setLoading(true)
    viewModel.fetchMoreGame()
  }
  
}

extension HomeViewController: SearchDelegate {
  
  func search(_ searchText: String) {
    viewModel.searchSubject.send(searchText)
  }
  
  func searchCancelled() {
    viewModel.cancelSearch()
  }
}

extension HomeViewController: FavoriteDelegate {
  
  func favorite(item: GameViewModel) {
    viewModel.addFavorite(item)
  }
  
}
