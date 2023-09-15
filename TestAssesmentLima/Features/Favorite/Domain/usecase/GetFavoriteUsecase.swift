//
//  FavoriteUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//  Copyright (c) 2023 Ilham Hadi P. All rights reserved.
//

import Foundation
import Combine

struct GetFavoriteUsecase {
  
  //repository
  private let repository: FavoriteRepositoryLogic
  
  init(repository: FavoriteRepositoryLogic) {
    self.repository = repository
  }
  
  func fetch() -> AnyPublisher<[Favorite], NError>{
    return repository.fetchGame().eraseToAnyPublisher()
  }
  
}
