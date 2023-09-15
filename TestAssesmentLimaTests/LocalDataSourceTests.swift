//
//  FavoriteLocalDataSourceTests.swift
//  TestAssesmentLimaTests
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import XCTest
import Combine
import CoreData
@testable import TestAssesmentLima

class FavoriteLocalDataBaseMock: FavoriteLocalDataSourceLogic {
  
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func fetch() -> AnyPublisher<[Favorite], NError> {
    
    return Future<[Favorite], NError> { completion in
      
      completion(.success([]))
      
    }.eraseToAnyPublisher()
    
  }
  
  func delete(with id: Int) -> AnyPublisher<Bool, TestAssesmentLima.NError> {
    
    return Future<Bool, NError> { completion in
      
      return completion(.success(true))
      
    }.eraseToAnyPublisher()
    
  }
  
  func add(id: Int, title: String, image: String, rating: Float, date: String) -> AnyPublisher<Bool, TestAssesmentLima.NError> {
    fatalError()
  }
  
  func search(_ text: String) -> AnyPublisher<[TestAssesmentLima.Favorite], TestAssesmentLima.NError> {
    fatalError()
  }
  
}

final class LocalDataSourceTests: XCTestCase {
  
  var context: NSManagedObjectContext?
  
  override func setUp() {
    super.setUp()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else { return }
    
    context = appDelegate.persistentContainer.viewContext
  }
  
  var cancellable = Set<AnyCancellable>()
  
  func testFetchFavoriteFromLocalDataAndReturnEmpty(){
    
    //given
    let sut = FavoriteLocalDataSourceImpl(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    var list: [Favorite] = []
    
    //when
    let result = sut.fetch()
    result
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { models in
        list = models
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertEqual(list.count, 0)
    XCTAssertTrue(finised)
  }
  
  func testAddGameToDatabase(){
    
    //given
    let sut = DetailLocalDataSource(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    var success: Bool = false
    
    //when
    sut.addGame(id: 1234,
                title: "Zero sum game",
                image: "Gambar",
                rating: 4.5,
                date: "2021-03-01")
    .receive(on: DispatchQueue.main)
    .sink { completion in
      switch completion {
      case .failure(let err):
        error = err
      case .finished:
        finised = true
      }
      expectation.fulfill()
    } receiveValue: { value in
      success = value
    }
    .store(in: &cancellable)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(finised)
    XCTAssertTrue(success)
    
  }
  
  func testUpdateFavoriteToDatabase(){
    
    //given
    let sut = DetailLocalDataSource(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    
    //when
    let result = sut.updateGame(id: 1234,
                                title: "Zero sum game",
                                image: "Gambar",
                                rating: 4.5,
                                date: "2021-03-01")
    
    result.receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { _ in }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error, "should be error")
    XCTAssertTrue(finised, "should be not finished")
  }
  
  func testFetchFavoriteFromLocalData(){
    
    //given
    let sut = FavoriteLocalDataSourceImpl(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    var list: [Favorite] = []
    
    //when
    sut.fetch()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { models in
        list = models
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(list.count == 1)
    XCTAssertEqual(list.map{ $0.favID }.first, 1234)
    XCTAssertTrue(finised)
  }
  
  func testAddDataWithSameIDToDatabaseAndReturnFailure(){
    //given
    let sut = DetailLocalDataSource(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    var success: Bool = false
    
    //when
    sut.addGame(id: 1234,
                title: "Zero sum game",
                image: "Gambar",
                rating: 4.5,
                date: "2021-03-01")
    .receive(on: DispatchQueue.main)
    .sink { completion in
      switch completion {
      case .failure(let err):
        error = err
      case .finished:
        finised = true
      }
      expectation.fulfill()
    } receiveValue: { value in
      success = value
    }
    .store(in: &cancellable)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNotNil(error)
    XCTAssertFalse(finised)
    XCTAssertFalse(success)
    
  }
  
  func testSearchFavoriteAndReturenEmpty() {
    //given
    let sut = FavoriteLocalDataSourceImpl(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finished: Bool = false
    var favorites: [Favorite] = []
    
    //when
    sut.search("")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let err):
          error = err
        case .finished:
          finished = true
        }
        
        expectation.fulfill()
        
      } receiveValue: { items in
        favorites = items
      }
      .store(in: &cancellable)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(finished)
    XCTAssertTrue(favorites.isEmpty)
  }
  
  func testDeleteDataAndReturnSuccess(){
    
    //given
    let sut = FavoriteLocalDataSourceImpl(context: context!)
    let expectation = expectation(description: "Promise")
    
    var error: NError?
    var finised: Bool = false
    var success: Bool = false
    
    //when
    sut.fetch()
      .receive(on: DispatchQueue.main)
      .filter{$0.count > 0}
      .flatMap { favorites in
        sut.delete(with: Int(favorites[0].favID))
      }
      .eraseToAnyPublisher()
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { value in
        success = value
      }
      .store(in: &cancellable)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(finised)
    XCTAssertTrue(success)
  }
  
}
