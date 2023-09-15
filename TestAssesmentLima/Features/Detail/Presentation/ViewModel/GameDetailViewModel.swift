//
//  GameDetailViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation

struct GameDetailViewModel {
  let id: Int
  let title: String
  let developerName: String
  let description: String
  let image: String
  let released: String
  let rating: Float
  let playedCount: Int
  
  init(id: Int,
       title: String,
       image: String,
       developerName: String,
       description: String,
       released: String,
       rating: Float,
       playedCount: Int) {
    
    self.id = id
    self.title = title
    self.image = image
    self.developerName = developerName
    self.description = description
    self.released = released
    self.rating = rating
    self.playedCount = playedCount
  }
  
  var ratingStr: String {
    return "⭐️\(rating)"
  }
  
  var played: String {
    return "🎮 \(playedCount) played"
  }
  
  var releaseDate: String {
    return "Release date \(released)"
  }
  
}
