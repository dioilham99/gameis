//
//  HomeRepository.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

protocol HomeRepositoryLogic: AddFavoriteLogic {
  
  func fetchGame(param: [String: Any]) -> AnyPublisher<GameEntity, NError>
  
}
