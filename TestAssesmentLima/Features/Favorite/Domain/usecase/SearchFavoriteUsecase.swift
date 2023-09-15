//
//  SearchFavoriteUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 13/02/23.
//

import Foundation
import Combine

struct SearchFavoriteUsecase: BaseCombineUsecase {
  
  typealias T = [Favorite]
  
  typealias P = [String: String]
  
  typealias E = NError
  
  private let repository: FavoriteRepositoryLogic
  
  init(repository: FavoriteRepositoryLogic) {
    self.repository = repository
  }
  
  func execute(param: [String : String]) -> AnyPublisher<[Favorite], NError> {
    
    Just(param["search"])
      .compactMap{ $0 }
      .drop(while: {$0.isEmpty})
      .flatMap{self.repository.searchGame(searchText: $0)}
      .eraseToAnyPublisher()
  }
  
}
