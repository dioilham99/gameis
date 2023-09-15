//
//  GameDetailModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation

struct GameDetailModel: Codable {
  
  let id: Int
  let slug: String?
  let name: String?
  let image: String?
  let description: String?
  let rating: Double?
  let released: String?
  let developers: [Developer]?
  let status: AddedByStatus?
  
  enum CodingKeys: String, CodingKey {
    case id, slug, name
    case rating
    case released
    case description = "description_raw"
    case developers
    case status = "added_by_status"
    case image = "background_image"
  }
  
}

struct AddedByStatus: Codable {
  let playing: Int?
}

struct Developer: Codable {
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case name
  }
}

