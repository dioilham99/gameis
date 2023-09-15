//
//  GetGameListUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

struct GetGameUsecase: BaseCombineUsecase {
  
  typealias T = GameEntity
  
  typealias P = [String: Any]
  
  typealias E = NError
  
  let repository: HomeRepositoryLogic
  
  init(repository: HomeRepositoryLogic) {
    self.repository = repository
  }
  
  func execute(param: [String: Any]) -> AnyPublisher<GameEntity, NError> {
    return repository.fetchGame(param: param)
  }
  
}
