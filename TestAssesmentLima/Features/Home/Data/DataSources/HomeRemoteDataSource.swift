//
//  HomeRemoteDataSource.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

protocol Searchable {
  func search<T>(of: T.Type, searchTxt: String) -> AnyPublisher<T, NError> where T: Codable
}

protocol HomeRemoteDataSourceLogic {
  func fetchGame(param: [String: Any]) -> AnyPublisher<GameModel, NError>
}

struct HomeRemoteDataSource: HomeRemoteDataSourceLogic, Searchable {
  
  private let networkManager: NetworkManagerLogic
  
  init(networkManager: NetworkManagerLogic) {
    self.networkManager = networkManager
  }
  
  func fetchGame(param: [String : Any]) -> AnyPublisher<GameModel, NError> {
    let page = param["page"] as? Int
    let search = param["search"] as? String
    guard let url = URL(string: API.BASE_URL.appending("games?key=\(API.API_KEY)&page_size=10&page=\(page ?? 1)&search=\(search ?? "")"))
    else { fatalError() }
    
    let urlRequest = URLRequest(url: url)
    
    return networkManager.getRequest(of: GameModel.self, url: urlRequest)
      .receive(on: DispatchQueue.main)
      .mapError{ NError(message: $0.localizedDescription) }
      .eraseToAnyPublisher()
    
  }
  
  func search<T>(of: T.Type, searchTxt: String) -> AnyPublisher<T, NError> where T : Decodable, T : Encodable {
    guard let url = URL(string: API.BASE_URL.appending("games?search=\(searchTxt)&key=\(API.API_KEY)"))
    else { fatalError() }
    
    let urlRequest = URLRequest(url: url)
    
    return networkManager.getRequest(of: T.self, url: urlRequest)
      .receive(on: DispatchQueue.main)
      .mapError{ NError(message: $0.localizedDescription) }
      .eraseToAnyPublisher()
  }
  
}
