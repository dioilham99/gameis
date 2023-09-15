//
//  AppDependencyManager.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 13/02/23.
//

import Foundation
import CoreData
import UIKit

class AppDependencyManager {
  
  let dic: DICProtocol
  
  init(dic: DICProtocol) {
    self.dic = dic
  }
  
  func setupDependencies(){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else { return }
    
    let context = appDelegate.persistentContainer.viewContext
    
    dic.register(type: NSManagedObjectContext.self) { _ in
      return context
    }
    
    registerNetworkManager()
    registerHomeDependencies()
    registerFavoriteDependencies()
    registerDetailDependencies()
    
  }
  
  func registerNetworkManager() {
    let network = NetworkManager()
    dic.register(type: NetworkManagerLogic.self) { _ in
      return network
    }
  }
  
  func registerHomeDependencies(){
    
    let networkManager = dic.resolve(type: NetworkManagerLogic.self)!
    
    let context = dic.resolve(type: NSManagedObjectContext.self)!
    
    func makeHomeLocalDataSource() -> HomeLocalDataSourceLogic & AddFavoriteLogic{
      return HomeLocalDataSource(context: context)
    }
    
    func makeHomeRemoteDataSource() -> HomeRemoteDataSourceLogic{
      return HomeRemoteDataSource(networkManager: networkManager)
    }
    
    func makeHomeRepository() -> HomeRepositoryLogic {
      return HomeRepositoryImpl(remoteDataSource: makeHomeRemoteDataSource(),
                                localDataSource: makeHomeLocalDataSource())
    }
    
    let homeRepository = makeHomeRepository() as AnyObject
    
    dic.register(type: HomeRepositoryLogic.self) { _ in
      return homeRepository
    }
    
  }
  
  func registerFavoriteDependencies() {
    
    let context = dic.resolve(type: NSManagedObjectContext.self)!
    
    func makeLocalDataSource() -> FavoriteLocalDataSourceLogic {
      return FavoriteLocalDataSourceImpl(context: context)
    }
    
    func makeRepository() -> FavoriteRepositoryLogic {
      return FavoriteRepositoryImpl(localDataSource: makeLocalDataSource())
    }
    
    
    let favoriteRepository = makeRepository() as AnyObject
    
    dic.register(type: FavoriteRepositoryLogic.self) { _ in
      return favoriteRepository
    }
    
  }
  
  func registerDetailDependencies() {
    
    let networkManager = dic.resolve(type: NetworkManagerLogic.self)!
    
    let context = dic.resolve(type: NSManagedObjectContext.self)!
    
    func makeDetailLocalDataSource() -> DetailLocalDataSourceLogic & AddFavoriteLogic {
      return DetailLocalDataSource(context: context)
    }
    
    func makeDetailRemoteDataSource() -> DetailRemoteDataSourceLogic {
      return DetailRemoteDataSource(networkManager: networkManager)
    }
    
    func makeRepository() -> DetailRepositoryLogic & AddFavoriteLogic {
      return DetailRepositoryImpl(remoteDataSource: makeDetailRemoteDataSource(),
                                  localDataSource: makeDetailLocalDataSource())
    }
    
    let detailRepository = makeRepository() as AnyObject
    
    dic.register(type: DetailRepositoryLogic.self) { _ in
      return detailRepository
    }
  }
  
}
