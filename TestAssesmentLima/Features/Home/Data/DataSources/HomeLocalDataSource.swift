//
//  HomeLocalDataSource.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine
import CoreData

protocol HomeLocalDataSourceLogic {
  
}

struct HomeLocalDataSource: HomeLocalDataSourceLogic & AddFavoriteLogic{
  
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func addGame(id: Int,
               title: String,
               image: String,
               rating: Float,
               date: String) -> AnyPublisher<Bool, NError> {
    
    return Future<Bool, NError> { completion in
      
      let fetchRequest = Favorite.fetchFavorite()
      fetchRequest.predicate = NSPredicate(format: "favID == %i", id)
      
      do {
        
        if let _ = try self.context.fetch(fetchRequest).first {
          
          completion(.failure(NError(message: "Already saved")))
          
        } else {
          
          let favorite = Favorite(context: self.context)
          favorite.favID = Int16(id)
          favorite.title = title
          favorite.image = image
          favorite.date = date
          favorite.rating = rating
          
          try self.context.save()
          completion(.success(true))
        }
      }catch {
        completion(.failure(NError(message: error.localizedDescription)))
      }
    }
    .eraseToAnyPublisher()
  }
  
  
}
