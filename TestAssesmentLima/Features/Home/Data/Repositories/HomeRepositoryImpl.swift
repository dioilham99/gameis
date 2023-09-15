//
//  HomeRepositoryImpl.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

struct HomeRepositoryImpl: HomeRepositoryLogic, AddFavoriteLogic {
  
  let remoteDataSource: HomeRemoteDataSourceLogic
  let localDataSource: HomeLocalDataSourceLogic & AddFavoriteLogic
  
  init(remoteDataSource: HomeRemoteDataSourceLogic,
       localDataSource: HomeLocalDataSourceLogic & AddFavoriteLogic) {
    
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }
  
  func fetchGame(param: [String : Any]) -> AnyPublisher<GameEntity, NError> {
    
    return remoteDataSource.fetchGame(param: param)
      .compactMap{ model in
        return GameEntity(
          count: model.count ?? 0,
          data: model.games?.map{
            return GameEntity.GameData(id: $0.id ?? 0,
                                       title: $0.name ?? "",
                                       image: $0.image ?? "",
                                       rating: Float($0.rating ?? 0.0),
                                       date: $0.released ?? "")
          } ?? []
        )
      }.eraseToAnyPublisher()
    
  }
  
  func addGame(id: Int,
               title: String,
               image: String,
               rating: Float,
               date: String) -> AnyPublisher<Bool, NError> {
    
    localDataSource.addGame(
      id: id,
      title: title,
      image: image,
      rating: rating,
      date: date
    )
    .eraseToAnyPublisher()
    
  }
  
}
