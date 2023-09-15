//
//  GameModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation

struct GameModel: Codable {
  let count: Int?
  let next: String?
  let previous: String?
  let games: [GameData]?
  
  enum CodingKeys: String, CodingKey {
    case count, next, previous
    case games = "results"
  }
}

struct GameData: Codable {
  let id: Int?
  let slug: String?
  let name: String?
  let released: String?
  let image: String?
  let rating: Double?
  
  enum CodingKeys: String, CodingKey {
    case id, slug, released, name
    case rating
    case image = "background_image"
  }
  
}
