//
//  GameEntity.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation

struct GameEntity {
  
  let count: Int
  let data: [GameData]
  
  struct GameData {
    let id: Int
    let title: String
    let image: String
    let rating: Float
    let date: String
  }
  
}
