//
//  FavoriteRemoteDataSource.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//  Copyright (c) 2023 Ilham Hadi P. All rights reserved.
//

import Foundation
import Combine
import CoreData

protocol FavoriteLocalDataSourceLogic {
  
  func fetch() -> AnyPublisher<[Favorite], NError>
  
  func add(id: Int,
           title: String,
           image: String,
           rating: Float,
           date: String) -> AnyPublisher<Bool, NError>
  
  func delete(with id: Int) -> AnyPublisher<Bool, NError>
  
  func search(_ text: String) -> AnyPublisher<[Favorite], NError>
  
  
}

struct FavoriteLocalDataSourceImpl: FavoriteLocalDataSourceLogic{
  
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func fetch() -> AnyPublisher<[Favorite], NError> {
    
    return Future<[Favorite], NError> { completion in
      
      let fetchRequest = Favorite.fetchFavorite()
      
      do {
        let favorite = try self.context.fetch(fetchRequest)
        return completion(.success(favorite))
      }catch {
        return completion(.failure(NError(message: error.localizedDescription)))
      }
      
    }.eraseToAnyPublisher()
    
  }
  
  func add(id: Int,
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
    }.eraseToAnyPublisher()
  }
  
  func delete(with id: Int) -> AnyPublisher<Bool, NError> {
    
    return Future<Bool, NError> { completion in
      
      let fetchRequest = Favorite.fetchFavorite()
      
      fetchRequest.predicate = NSPredicate(format: "favID == %i", id)
      
      do {
        
        if let favorite = try context.fetch(fetchRequest).first {
          
          context.delete(favorite)
          
          try context.save()
          
          completion(.success(true))
        }else {
          completion(.failure(NError(message: "Data with this slug has not found!")))
        }
      }catch {
        let nserror = error as NSError
        completion(.failure(NError(message: nserror.localizedDescription)))
      }
      
    }.eraseToAnyPublisher()
    
  }
  
  func search(_ text: String) -> AnyPublisher<[Favorite], NError> {
    
    return Future<[Favorite], NError> { completion in
      
      let fetchRequest = Favorite.fetchFavorite()
      
      fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", text)
      
      do {
        let favorites = try context.fetch(fetchRequest)
        
        completion(.success(favorites))
        
      }catch {
        let nserror = error as NSError
        completion(.failure(NError(message: nserror.localizedDescription)))
      }
      
    }.eraseToAnyPublisher()
  }
  
}
