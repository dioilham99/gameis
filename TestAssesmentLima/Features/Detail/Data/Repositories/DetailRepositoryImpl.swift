//
//  DetailRepositoryImpl.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

struct DetailRepositoryImpl: DetailRepositoryLogic, AddFavoriteLogic {
  
  private let remoteDataSource: DetailRemoteDataSourceLogic
  private let localDataSource: AddFavoriteLogic
  
  init(remoteDataSource: DetailRemoteDataSourceLogic, localDataSource: AddFavoriteLogic) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }
  
  func fetchDetail(param: [String : Any]) -> AnyPublisher<GameDetailEntity, NError> {
    return remoteDataSource.fetchDetail(param: param)
      .map { model in
        return GameDetailEntity(id: model.id,
                                title: model.name ?? "",
                                image: model.image ?? "",
                                developerName: model.developers?[0].name ?? "",
                                description: model.description ?? "",
                                released: model.released ?? "",
                                rating: Float(model.rating ?? 0.0),
                                playedCount: model.status?.playing ?? 0)
        
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

