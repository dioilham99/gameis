//
//  DetailRemoteDataSource.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

protocol DetailRemoteDataSourceLogic {
  
  func fetchDetail(param: [String: Any]) -> AnyPublisher<GameDetailModel, NError>
  
}

struct DetailRemoteDataSource: DetailRemoteDataSourceLogic {
  
  private let networkManager: NetworkManagerLogic
  
  init(networkManager: NetworkManagerLogic) {
    self.networkManager = networkManager
  }
  
  func fetchDetail(param: [String: Any]) -> AnyPublisher<GameDetailModel, NError> {
    
    guard let id = param["id"] as? Int,
      let url = URL(string: API.BASE_URL.appending("games/\(id)?key=\(API.API_KEY)"))
    else { fatalError() }
    
    let urlRequest = URLRequest(url: url)
    
    return networkManager.getRequest(of: GameDetailModel.self, url: urlRequest)
      .receive(on: DispatchQueue.main)
      .mapError{ NError(message: $0.localizedDescription) }
      .eraseToAnyPublisher()
    
  }
  
  
}
