//
//  AddFavoriteUsecase.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

class AddFavoriteUsecase {
  
  private let repository: AddFavoriteLogic
  
  init(repository: AddFavoriteLogic) {
    self.repository = repository
  }
  
  func addToFavorite(id: Int,
                     title: String,
                     image: String,
                     rating: Float,
                     date: String) -> AnyPublisher<Bool, NError> {
    
    return repository.addGame(id: id,
                              title: title,
                              image: image,
                              rating: rating,
                              date: date)
  }
  
}
