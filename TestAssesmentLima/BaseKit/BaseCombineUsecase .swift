//
//  BaseCombineUsecase .swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

public protocol BaseCombineUsecase {
  
  associatedtype T
  associatedtype P
  associatedtype E: Error
  
  func execute(param: P) -> AnyPublisher<T, E>
  
}
