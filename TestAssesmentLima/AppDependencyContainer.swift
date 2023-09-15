//
//  AppDependencyContainer.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import UIKit
import CoreData

class AppDependencyContainer {
  
  let sharedViewModel: AppViewModel
  let dic: DICProtocol
  
  init(dependencyManager: AppDependencyManager){
    
    func makeMainViewModel() -> AppViewModel {
      return AppViewModel()
    }
    
    func makeNetworkManager() -> NetworkManagerLogic {
      return NetworkManager()
    }
    
    self.dic = dependencyManager.dic
    self.sharedViewModel = makeMainViewModel()
    
  }
  
  func makeViewController() -> AppContainerController {

    let context = dic.resolve(type: NSManagedObjectContext.self)!
    
    return AppContainerController(
      context: context,
      viewModel: sharedViewModel,
      mainViewController: makeMainViewController()
    )
    
  }
  
  private func makeMainViewController() -> MainViewController {
    
    return MainDependencyContainer(appDependencyContainer: self).makeTabController()
    
  }
  
}
