//
//  AppContainerController.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import UIKit
import Combine
import CoreData

class AppContainerController: NiblessViewController {
  
  // MARK: - Properties
  //ViewModel
  let viewModel: AppViewModel
  let context: NSManagedObjectContext
  
  //Child View Controllers
  var mainViewController: MainViewController
  
  var cancellable = Set<AnyCancellable>()
  
  init(context: NSManagedObjectContext,
       viewModel: AppViewModel,
       mainViewController: MainViewController){
    
    self.context = context
    self.viewModel = viewModel
    self.mainViewController = mainViewController
    
    super.init()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    observeViewModel()
  }
  
  private func observeViewModel() {
    let publisher = viewModel.$view.removeDuplicates().eraseToAnyPublisher()
    publisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] view in
        guard let self = self else { return }
        self.present(view)
      }.store(in: &cancellable)
  }
  
  func present(_ view: MainView) {
    switch view {
    case .main:
      presentMainView()
    case .detail:
      break
    }
  }
  
  private func presentMainView() {
    addFullScreen(childViewController: mainViewController)
  }
  
  
}
