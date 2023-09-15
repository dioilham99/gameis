//
//  MainViewModel.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import Combine

public class AppViewModel: MainResponder{
  
  @Published public private(set) var view: MainView = .main
  
  public init() {}
  
  public func detail(id: Int) {
    view = .detail(id: id)
  }
  
}
