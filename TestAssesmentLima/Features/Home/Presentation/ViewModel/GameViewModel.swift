//
//  GameViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation

struct GameViewModel {
  let id: Int
  let title: String
  let image: String
  let rating: Float
  let date: String
  let tapAction: (_ id: Int) -> Void?
  
  init(id: Int,
       title: String,
       image: String,
       rating: Float,
       date: String,
       tapAction: @escaping (_ id: Int) -> Void) {
    
    self.id = id
    self.title = title
    self.image = image
    self.rating = rating
    self.date = date
    self.tapAction = tapAction
  }
  
  var releasedDate: String {
    return "Released \(date)"
  }
  
  var rate: String {
    return "⭐️ \(rating)"
  }
}
