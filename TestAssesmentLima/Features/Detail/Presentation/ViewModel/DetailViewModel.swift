//
//  DetailViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation
import Combine

class DetailViewModel {
  
  //Dependencies
  let detailUsecase: GetDetailGameUsecase
  let addFavoriteUsecase: AddFavoriteUsecase
  
  var data: GameDetailViewModel?
  var dataSubject = PassthroughSubject<GameDetailViewModel, NError>()
  var favoriteSubject = PassthroughSubject<Bool, NError>()
  var messageSubject = PassthroughSubject<String, Never>()
  var loadingSubject = PassthroughSubject<Bool, Never>()
  
  private var cancellable = Set<AnyCancellable>()
  
  init(detailUsecase: GetDetailGameUsecase,
       addFavoriteUsecase: AddFavoriteUsecase) {
    
    self.detailUsecase = detailUsecase
    self.addFavoriteUsecase = addFavoriteUsecase
  }
  
  func fetchDetail(with id: Int){
    
    loadingSubject.send(true)
    
    detailUsecase.execute(param: ["id": id])
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion{
        case .failure:
          break
        case .finished:
          break
        }
        
        self?.loadingSubject.send(false)
        
      } receiveValue: { [weak self] model in
        
        self?.loadingSubject.send(false)
        
        let data = GameDetailViewModel(id: model.id,
                                       title: model.title,
                                       image: model.image,
                                       developerName: model.developerName,
                                       description: model.description,
                                       released: model.released,
                                       rating: model.rating,
                                       playedCount: model.playedCount)
        
        self?.dataSubject.send(data)
        self?.data = data
      }
      .store(in: &cancellable)
  }
  
  func addToFavorite(){
    
    guard let data = data else { return }
    
    addFavoriteUsecase.addToFavorite(id: data.id,
                                     title: data.title,
                                     image: data.image,
                                     rating: data.rating,
                                     date: data.released)
    .receive(on: DispatchQueue.main)
    .sink { [weak self] completion in
      switch completion {
      case .failure:
        self?.messageSubject.send("Already saved!")
      case .finished:
        break
      }
      
    } receiveValue: { [weak self] value in
      self?.messageSubject.send("Success add to favorite")
    }
    .store(in: &cancellable)
    
  }
  
}
