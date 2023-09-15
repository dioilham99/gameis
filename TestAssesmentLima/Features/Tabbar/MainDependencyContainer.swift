//
//  MainDependencyContainer.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import CoreData

class MainDependencyContainer {
  
  let sharedViewModel: AppViewModel
  
  let dic: DICProtocol
  
  init(appDependencyContainer: AppDependencyContainer) {
    sharedViewModel = appDependencyContainer.sharedViewModel
    dic = appDependencyContainer.dic
  }
  
  func makeTabController() -> MainViewController {
    
    let repository = dic.resolve(type: HomeRepositoryLogic.self)!
    
    func makeFetchGameUsecase() -> GetGameUsecase {
      return GetGameUsecase(repository: repository)
    }
    
    func makeAddFavoriteUsecase() -> AddFavoriteUsecase {
      return AddFavoriteUsecase(repository: repository)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
      return HomeViewModel(responder: sharedViewModel,
                           fetchGameUsecase: makeFetchGameUsecase(),
                           addFavoriteUsecase: makeAddFavoriteUsecase())
    }
    
    func makeHomeController() -> HomeViewController {
      return HomeViewController(viewModel: makeHomeViewModel())
    }
    
    func makeFavoriteController() -> FavoriteViewController {
      
      let repository = dic.resolve(type: FavoriteRepositoryLogic.self)!
      
      func makeFetchUsecase() -> GetFavoriteUsecase {
        return GetFavoriteUsecase(repository: repository)
      }
      
      func makeDeleteUsecase() -> DeleteFavoriteUsecase{
        return DeleteFavoriteUsecase(repository: repository)
      }
      
      func makeSearchUsecase() -> SearchFavoriteUsecase {
        return SearchFavoriteUsecase(repository: repository)
      }
      
      func makeFavoriteViewModel() -> FavoriteViewModel {
        return FavoriteViewModel(responder: sharedViewModel,
                                 fetchUsecase: makeFetchUsecase(),
                                 deleteUsecase: makeDeleteUsecase(),
                                 searchUsecase: makeSearchUsecase())
      }
      
      return FavoriteViewController(favoriteViewModel: makeFavoriteViewModel())
    }
    
    let detailViewControllerFactory = { id in
      self.makeDetailViewController(id: id)
    }
    
    return MainViewController(
      sharedViewModel: sharedViewModel,
      homeViewController: makeHomeController(),
      favoriteViewController: makeFavoriteController(),
      detailViewControllerFactory: detailViewControllerFactory
    )
  }
  
  func makeDetailViewController(id: Int) -> DetailViewController {

    let detailRepository = dic.resolve(type: DetailRepositoryLogic.self)!
    
    let favoriteRepository = dic.resolve(type: FavoriteRepositoryLogic.self)!
    
    func makeDetailGameUsecase() -> GetDetailGameUsecase {
      return GetDetailGameUsecase(repository: detailRepository)
    }
    
    func makeAddFavoriteUsecase() -> AddFavoriteUsecase {
      return AddFavoriteUsecase(repository: favoriteRepository)
    }
    
    func makeDetailViewModel() -> DetailViewModel {
      return DetailViewModel(detailUsecase: makeDetailGameUsecase(),
                             addFavoriteUsecase: makeAddFavoriteUsecase())
    }
    
    return DetailViewController(id: id, viewModel: makeDetailViewModel())
  }
  
}
