//
//  Favorite+CoreDataProperties.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 11/02/23.
//

import Foundation
import CoreData

extension Favorite {
  @NSManaged var favID: Int16
  @NSManaged var title: String
  @NSManaged var image: String
  @NSManaged var rating: Float
  @NSManaged var date: String
  
  static func createWith(id: Int16,
                         slug: String,
                         title: String,
                         image: String,
                         date: String,
                         rating: Float,
                         using context: NSManagedObjectContext) {
    
    let favorite = Favorite(context: context)
    favorite.favID = id
    favorite.title = title
    favorite.image = image
    favorite.date = date
    favorite.rating = rating
    
    do {
      try context.save()
    }catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror)")
    }
    
  }
  
  static func fetchFavorite() -> NSFetchRequest<Favorite> {
    let fetchRequest = NSFetchRequest<Favorite>(entityName: "Favorite")
    return fetchRequest
  }
  
}
