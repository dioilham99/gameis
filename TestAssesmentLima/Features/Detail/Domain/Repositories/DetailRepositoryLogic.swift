//
//  DetailRepositoryLogic.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

protocol DetailRepositoryLogic {
  
  func fetchDetail(param: [String: Any]) -> AnyPublisher<GameDetailEntity, NError>
  
}
 
