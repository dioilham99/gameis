//
//  HomeViewController.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import UIKit
import Combine

class MainViewController: UITabBarController {
  
  //Dependencies
  let sharedViewModel: AppViewModel
  
  //Factories
  let makeDetailViewController: (_ id: Int) -> DetailViewController
  
  //Child controllers
  var homeViewController: HomeViewController
  var favoriteViewController: FavoriteViewController
  var detailViewController: DetailViewController?
  
  var cancellable = Set<AnyCancellable>()
  
  init(sharedViewModel: AppViewModel,
       homeViewController: HomeViewController,
       favoriteViewController: FavoriteViewController,
       detailViewControllerFactory: @escaping (_ id: Int) -> DetailViewController) {
    
    self.sharedViewModel = sharedViewModel
    self.homeViewController = homeViewController
    self.favoriteViewController = favoriteViewController
    self.makeDetailViewController = detailViewControllerFactory
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("currentVC \(String(describing: MainViewController.self))")
    
    view.backgroundColor = .white
    
    viewControllers = [createHome(), createFavorite()]
    
    observeViewModel()
  }
  
  fileprivate func createHome() -> UINavigationController {
    let nav = UINavigationController(rootViewController: homeViewController)
    nav.tabBarItem.image = UIImage(systemName: "house")
    nav.tabBarItem.title = "Home"
    return nav
  }
  
  fileprivate func createFavorite() -> UINavigationController {
    let nav = UINavigationController(rootViewController: favoriteViewController)
    nav.tabBarItem.image = UIImage(systemName: "heart")
    nav.tabBarItem.title = "Favorite"
    return nav
  }
  
  func present(_ view: MainView) {
    switch view {
    case .main:
      break
    case .detail(let id):
      navigateToDetailView(id: id)
    }
  }
  
  private func observeViewModel() {
    sharedViewModel.$view
      .receive(on: DispatchQueue.main)
      .sink { [weak self] view in
        guard let self = self else { return }
        self.present(view)
      }.store(in: &cancellable)
  }
  
  private func navigateToDetailView(id: Int) {
    
    if let _ = detailViewController {
      detailViewController = nil
    }
    
    detailViewController = makeDetailViewController(id)
    navigationController?.pushViewController(detailViewController!, animated: true)
  }
  
}
