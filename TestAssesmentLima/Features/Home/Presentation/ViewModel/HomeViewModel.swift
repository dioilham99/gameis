//
//  HomeViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

class HomeViewModel {
  
  private let responder: MainResponder
  private let fetchGameUsecase: GetGameUsecase
  private let addFavoriteUsecase: AddFavoriteUsecase
  
  var games: [GameViewModel] = []
  var filteredGames: [GameViewModel] = []
  var page = 1
  var search = ""
  var isNextPageAvaialble: Bool = false
  
  var gameSubject = PassthroughSubject<[GameViewModel], NError>()
  var errorSubject = PassthroughSubject<String, Never>()
  var searchSubject = PassthroughSubject<String, Never>()
  var messageSubject = PassthroughSubject<String, Never>()
  var loadingSubject = PassthroughSubject<Bool, Never>()
  private var cancellable = Set<AnyCancellable>()
  
  init(responder: MainResponder,
       fetchGameUsecase: GetGameUsecase,
       addFavoriteUsecase: AddFavoriteUsecase) {
    
    self.responder = responder
    self.fetchGameUsecase = fetchGameUsecase
    self.addFavoriteUsecase = addFavoriteUsecase
    
    searchSubject
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .sink(
        receiveCompletion: { print("completion: \($0)")},
        receiveValue: { [unowned self] searchTxt in
          self.search = searchTxt
          self.searchGame(searchTxt)
        }
      )
      .store(in: &cancellable)
    
  }
  
  func fetchGame() {
    
    loadingSubject.send(true)
    
    fetchGameUsecase.execute(param: [:])
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] completion in
        switch completion {
        case .failure(let error):
          errorSubject.send(error.message)
        case .finished:
          break
        }
        
        self.loadingSubject.send(false)
        
      } receiveValue: { [unowned self] entity in
        
        self.isNextPageAvaialble = true
        
        self.games = self.mapToViewModel(entity)
        self.gameSubject.send(self.games)
        
      }
      .store(in: &cancellable)
    
  }
  
  func fetchMoreGame() {
    
    if isNextPageAvaialble {
      
      page += 1
      
      fetchGameUsecase.execute(param: ["page": page,
                                       "search": search])
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] completion in
        switch completion {
        case .failure(let error):
          print("error load more")
          errorSubject.send(error.message)
        case .finished:
          break
        }
      } receiveValue: { [unowned self] entity in
        
        self.games.append(contentsOf: self.mapToViewModel(entity))
        self.gameSubject.send(self.games)
        
      }.store(in: &cancellable)
    }
    
  }
  
  func searchGame(_ searchText: String) {
    
    fetchGameUsecase.execute(param: ["search": searchText])
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          break
        case .finished:
          break
        }
      } receiveValue: { [unowned self] entity in
        
        self.isNextPageAvaialble = true
        
        self.games = self.mapToViewModel(entity)
        self.gameSubject.send(self.games)
        
      }.store(in: &cancellable)
    
  }
  
  func cancelSearch() {
    fetchGame()
  }
  
  func addFavorite(_ item: GameViewModel){
    addFavoriteUsecase.addToFavorite(id: item.id,
                                     title: item.title,
                                     image: item.image,
                                     rating: item.rating,
                                     date: item.date)
    .receive(on: DispatchQueue.main)
    .sink(
      receiveCompletion: { [unowned self] completion in
        switch completion {
        case .failure(let error):
          self.errorSubject.send(error.message)
        case .finished:
          break
        }
      },
      receiveValue: { value in
        self.messageSubject.send("Success add to favorite")
      }
    )
    .store(in: &cancellable)
  }
  
  fileprivate func mapToViewModel(_ entity: GameEntity) -> [GameViewModel]{
    return entity.data.map{
      GameViewModel(id: $0.id,
                    title: $0.title,
                    image: $0.image,
                    rating: $0.rating,
                    date: $0.date) { [unowned self] id in
        
        self.responder.detail(id: id)
        
      }
    }
  }
  
}
