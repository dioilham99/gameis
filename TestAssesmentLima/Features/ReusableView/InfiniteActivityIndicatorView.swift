//
//  InfiniteActivityIndicatorView.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation
import UIKit

class InfiniteScrollActivityView: UIView {
  
  var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
  
  static let defaultHeight:CGFloat = 60.0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupActivityIndicator()
  }
  
  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    setupActivityIndicator()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
  }
  
  func setupActivityIndicator() {
    activityIndicatorView.style = .medium
    activityIndicatorView.hidesWhenStopped = true
    self.addSubview(activityIndicatorView)
  }
  
  func stopAnimating() {
    self.activityIndicatorView.stopAnimating()
    self.isHidden = true
  }
  
  func startAnimating() {
    self.isHidden = false
    self.activityIndicatorView.startAnimating()
  }
}
