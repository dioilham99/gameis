//
//  NetworkManager.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

protocol NetworkManagerLogic {
  func getRequest<T>(of: T.Type, url: URLRequest) -> AnyPublisher<T, Error> where T: Codable
}

class NetworkManager: NetworkManagerLogic {
  
  func getRequest<T>(of: T.Type, url: URLRequest) -> AnyPublisher<T, Error> where T: Codable {
    
    let urlSession = URLSession(configuration: .default)
    
    return urlSession.dataTaskPublisher(for: url)
      .tryMap { (data, response) in
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          
          throw URLError(.badServerResponse)
        }
        
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
}
