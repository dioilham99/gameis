//
//  DetailViewController.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import UIKit
import Combine

public class DetailViewController: NiblessViewController {
  
  //Dependencies
  let viewModel: DetailViewModel
  let id: Int
  
  lazy var contentView: DetailView? = loadNibName()

  private var cancellable = Set<AnyCancellable>()
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    if self.isMovingFromParent {
      self.hideAnimatedActivityIndicatorView()
    }
    
  }
  
  init(id: Int, viewModel: DetailViewModel) {
    self.id = id
    self.viewModel = viewModel
    
    super.init()
  }
  
  public override func loadView() {
    super.loadView()
    
    if let contentView = contentView {
      view = contentView
      contentView.frame = view.bounds
    }
    
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    title = "Detail"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(tapFavorite))
    
    observeViewModel()
    
    viewModel.fetchDetail(with: id)
    
  }
  
  func observeViewModel() {
    viewModel.dataSubject
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] data in
        
        self?.contentView?.setData(data)
        
      }.store(in: &cancellable)
    
    viewModel.messageSubject
      .receive(on: DispatchQueue.main)
      .sink { [weak self] msg in
        self?.showAlert(alertText: "Success", alertMessage: msg)
      }
      .store(in: &cancellable)

    viewModel.loadingSubject
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        value ? self?.displayAnimatedActivityIndicatorView() : self?.hideAnimatedActivityIndicatorView()
      }
      .store(in: &cancellable)
    
  }
  
  @objc
  func tapFavorite(){
    viewModel.addToFavorite()
  }
  
  deinit{
    print("deinit detail view controller")
  }
  
}
