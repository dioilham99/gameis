//
//  FavoriteRepositoryLogic.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//  Copyright (c) 2023 Ilham Hadi P. All rights reserved.
//

import Foundation
import Combine

protocol AddFavoriteLogic {
  func addGame(id: Int,
               title: String,
               image: String,
               rating: Float,
               date: String) -> AnyPublisher<Bool, NError>
}

protocol FavoriteRepositoryLogic: AddFavoriteLogic {
  
  func fetchGame() -> AnyPublisher<[Favorite], NError>
  
  func deleteGame(with id: Int) -> AnyPublisher<Bool, NError>
  
  func searchGame(searchText: String) -> AnyPublisher<[Favorite], NError>
}

