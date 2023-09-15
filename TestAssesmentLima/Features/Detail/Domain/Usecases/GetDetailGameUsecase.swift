//
//  GetDetailGameUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

class GetDetailGameUsecase: BaseCombineUsecase {
  
  typealias T = GameDetailEntity
  
  typealias P = [String: Any]
  
  typealias E = NError
  
  private let repository: DetailRepositoryLogic
  
  init(repository: DetailRepositoryLogic){
    self.repository = repository
  }
  
  func execute(param: [String : Any]) -> AnyPublisher<GameDetailEntity, NError> {
    repository.fetchDetail(param: param)
  }
  
}
