//
//  FavoriteRepositoryImpl.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//  Copyright (c) 2023 Ilham Hadi P. All rights reserved.
//

import Foundation
import Combine

struct FavoriteRepositoryImpl: FavoriteRepositoryLogic {
  
  private let localDataSource: FavoriteLocalDataSourceLogic
  
  init(localDataSource: FavoriteLocalDataSourceLogic) {
    self.localDataSource = localDataSource
  }
  
  func fetchGame() -> AnyPublisher<[Favorite], NError> {
    
    return localDataSource.fetch().eraseToAnyPublisher()
    
  }
  
  func addGame(id: Int,
               title: String,
               image: String,
               rating: Float,
               date: String) -> AnyPublisher<Bool, NError> {
    
    return localDataSource.add(id: id,
                               title: title,
                               image: image,
                               rating: rating,
                               date: date)
    .eraseToAnyPublisher()
  }
  
  func deleteGame(with id: Int) -> AnyPublisher<Bool, NError> {
    
    return localDataSource.delete(with: id).eraseToAnyPublisher()
    
  }
  
  func searchGame(searchText: String) -> AnyPublisher<[Favorite], NError> {
    return localDataSource.search(searchText).eraseToAnyPublisher()
  }
  
}
