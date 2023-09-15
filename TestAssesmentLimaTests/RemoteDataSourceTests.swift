//
//  HomRemoteDataSourceTests.swift
//  TestAssesmentLimaTests
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import XCTest
@testable import TestAssesmentLima
import Combine

class HomeRemoteDataSourceMock: HomeRemoteDataSourceLogic {
  
  private let networkManager: NetworkManagerLogic
  
  init(networkManager: NetworkManagerLogic) {
    self.networkManager = networkManager
  }
  
  func fetchGame(param: [String : Any]) -> AnyPublisher<GameModel, NError> {
    
    guard let apiKey = param["api_key"] as? String,
          let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)")
    else { fatalError() }
    
    let urlRequest = URLRequest(url: url)
    
    return networkManager.getRequest(of: GameModel.self, url: urlRequest)
      .receive(on: DispatchQueue.main)
      .mapError{ NError(message: $0.localizedDescription) }
      .eraseToAnyPublisher()
    
  }
  
}

final class RemoteDataSourceTests: XCTestCase {
  
  var remoteDataSource: HomeRemoteDataSourceLogic?
  var cancellable = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    
    remoteDataSource = HomeRemoteDataSourceMock(networkManager: NetworkManager())
  }
  
  func testFetchGameProduceError(){
    
    //given
    var error: NError?
    var finised: Bool = false
    var list: [GameModel] = []
    
    let expectation = expectation(description: "Promise")
    
    //when
    let result = remoteDataSource!.fetchGame(param: ["api_key": "923ojkjksdfdj922938893r98UDd=8"])
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
      } receiveValue: { model in
        list = [model]
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNotNil(error)
    XCTAssertTrue(list.isEmpty)
    XCTAssertFalse(finised)
  }
  
  func testFetchGameFromRealAPI(){
    //given
    var error: NError?
    var finised: Bool = false
    var list: [GameData] = []
    
    let sut = HomeRemoteDataSource(networkManager: NetworkManager())
    let expectation = expectation(description: "Promise")
    
    //when
    sut.fetchGame(param: [:])
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { model in
        list = model.games ?? []
        print("model")
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(list.count > 0)
    XCTAssertTrue(finised)
  }
  
  func testFetchDetailFromRealAPI(){
    //given
    var error: NError?
    var finised: Bool = false
    var name: String = ""
    
    let sut = DetailRemoteDataSource(networkManager: NetworkManager())
    let expectation = expectation(description: "Promise")
    
    //when
    sut.fetchDetail(param: ["id": 3498])
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { model in
        name = model.name ?? ""
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertEqual(name, "Grand Theft Auto V")
    XCTAssertTrue(finised)
  }
  
  func testSearchGameFromAPIAndReturnSuccess(){
    //given
    var error: NError?
    var finised: Bool = false
    var list: [GameData] = []
    
    let sut = HomeRemoteDataSource(networkManager: NetworkManager())
    let expectation = expectation(description: "Promise")
    
    //when
    sut.search(of: GameModel.self, searchTxt: "auto")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { model in
        list = model.games ?? []
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(list.count > 0)
    XCTAssertTrue(finised)
  }
  
  func testSearchGameFromAPIAndReturnEmpty(){
    //given
    var error: NError?
    var finised: Bool = false
    var list: [GameData] = []
    
    let sut = HomeRemoteDataSource(networkManager: NetworkManager())
    let expectation = expectation(description: "Promise")
    
    //when
    sut.search(of: GameModel.self, searchTxt: "123qwer456")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion{
        case .failure(let err):
          error = err
        case .finished:
          finised = true
        }
        expectation.fulfill()
      } receiveValue: { model in
        list = model.games ?? []
      }
      .store(in: &cancellable)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertNil(error)
    XCTAssertTrue(list.isEmpty)
    XCTAssertTrue(finised)
  }
  
}
