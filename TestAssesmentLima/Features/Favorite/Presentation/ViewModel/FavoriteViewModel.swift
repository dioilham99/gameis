//
//  FavoriteViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

class FavoriteViewModel {
  
  private let responder: MainResponder
  private let fetchUsecase: GetFavoriteUsecase
  private let deleteUsecase: DeleteFavoriteUsecase
  private let searchUsecase: SearchFavoriteUsecase
  
  let favoriteSubject = PassthroughSubject<[GameViewModel], NError>()
  let searchSubject = PassthroughSubject<String, Never>()
  
  var cancellable = Set<AnyCancellable>()
  
  init(responder: MainResponder,
       fetchUsecase: GetFavoriteUsecase,
       deleteUsecase: DeleteFavoriteUsecase,
       searchUsecase: SearchFavoriteUsecase) {
    
    self.responder = responder
    self.fetchUsecase = fetchUsecase
    self.deleteUsecase = deleteUsecase
    self.searchUsecase = searchUsecase
    
    observeView()
  }
  
  func observeView() {
    searchSubject
      .receive(on: DispatchQueue.main)
      .sink { [weak self] str in
        self?.searchFavorite(str)
      }
      .store(in: &cancellable)
  }
  
  func fetchFavorite(){
    fetchUsecase.fetch()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          break
        case .finished:
          break
        }
      } receiveValue: { [unowned self] favorites in
        
        let items = favorites.map{
          GameViewModel(id: Int($0.favID),
                        title: $0.title,
                        image: $0.image,
                        rating: $0.rating,
                        date: $0.date) { id in
            self.responder.detail(id: id)
          }
        }
        
        self.favoriteSubject.send(items)
        
      }
      .store(in: &cancellable)
    
  }
  
  func deleteFavorite(with id: Int){
    deleteUsecase.deleteFavorite(id: id)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          break
        case .finished:
          break
        }
      } receiveValue: { [unowned self] value in
        print(value)
      }
      .store(in: &cancellable)
  }
  
  func searchFavorite(_ text: String) {
    searchUsecase.execute(param: ["search": text])
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print("error \(error)")
        case .finished:
          break
        }
      } receiveValue: { [unowned self] favorites in
        let items = favorites.map{
          GameViewModel(id: Int($0.favID),
                        title: $0.title,
                        image: $0.image,
                        rating: $0.rating,
                        date: $0.date) { id in
            self.responder.detail(id: id)
          }
        }
        
        self.favoriteSubject.send(items)
      }
      .store(in: &cancellable)
    
  }
  
}
