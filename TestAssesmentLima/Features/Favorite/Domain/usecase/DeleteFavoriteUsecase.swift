//
//  DeleteFavoriteUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 11/02/23.
//

import Foundation
import Combine

struct DeleteFavoriteUsecase {
  
  private let repository: FavoriteRepositoryLogic
  
  init(repository: FavoriteRepositoryLogic) {
    self.repository = repository
  }
  
  func deleteFavorite(id: Int) -> AnyPublisher<Bool, NError>{
    repository.deleteGame(with: id)
  }
  
}
