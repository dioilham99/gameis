//
//  UIViewController+Extensions.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 10/02/23.
//

import Foundation
import UIKit

fileprivate let overlayViewTag: Int = 999
fileprivate let activityIndicatorViewTag: Int = 1000

extension UIViewController {
  
  public func addFullScreen(childViewController child: UIViewController) {
    guard child.parent == nil else {
      return
    }
    
    addChild(child)
    view.addSubview(child.view)
    
    child.view.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
      view.topAnchor.constraint(equalTo: child.view.topAnchor),
      view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
    ]
    constraints.forEach { $0.isActive = true }
    view.addConstraints(constraints)
    
    child.didMove(toParent: self)
  }
  
  public func remove(childViewController child: UIViewController?) {
    guard let child = child else {
      return
    }
    
    guard child.parent != nil else {
      return
    }
    
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
  
  public func loadNibName<T>() -> T? where T: UIView{
    let nib = Bundle.main.loadNibNamed(String(describing: T.self), owner: self)
    let nibView = nib?.first as? T
    return nibView
  }
  
  public func showAlert(alertText : String, alertMessage : String) {
    let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private var overlayContainerView: UIView {
    if let navigationView: UIView = navigationController?.view {
      return navigationView
    }
    return view
  }
  
  func displayAnimatedActivityIndicatorView() {
    overlayContainerView.displayAnimatedActivityIndicatorView()
  }
  
  func hideAnimatedActivityIndicatorView() {
    overlayContainerView.hideAnimatedActivityIndicatorView()
  }
  
}

extension UIView {
  func displayAnimatedActivityIndicatorView() {
    setActivityIndicatorView()
  }
  
  func hideAnimatedActivityIndicatorView() {
    removeActivityIndicatorView()
  }
  
  func loadNibName<T>() -> T? where T: UIView{
    let nib = Bundle.main.loadNibNamed(String(describing: T.self), owner: self)
    let nibView = nib?.first as? T
    return nibView
  }
}

extension UIView {
  private var activityIndicatorView: UIActivityIndicatorView {
    let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.tag = activityIndicatorViewTag
    return view
  }
  
  private var overlayView: UIView {
    let view: UIView = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.alpha = 0.5
    view.tag = overlayViewTag
    return view
  }
  
  private func setActivityIndicatorView() {
    guard !isDisplayingActivityIndicatorOverlay() else { return }
    let overlayView: UIView = self.overlayView
    let activityIndicatorView: UIActivityIndicatorView = self.activityIndicatorView
    
    //add subviews
    overlayView.addSubview(activityIndicatorView)
    addSubview(overlayView)
    
    //add overlay constraints
    overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    
    //add indicator constraints
    activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
    
    //animate indicator
    activityIndicatorView.startAnimating()
  }
  
  private func removeActivityIndicatorView() {
    guard let overlayView: UIView = getOverlayView(), let activityIndicator: UIActivityIndicatorView = getActivityIndicatorView() else {
      return
    }
    UIView.animate(withDuration: 0.2, animations: {
      overlayView.alpha = 0.0
      activityIndicator.stopAnimating()
    }) { _ in
      activityIndicator.removeFromSuperview()
      overlayView.removeFromSuperview()
    }
  }
  
  private func isDisplayingActivityIndicatorOverlay() -> Bool {
    getActivityIndicatorView() != nil && getOverlayView() != nil
  }
  
  private func getActivityIndicatorView() -> UIActivityIndicatorView? {
    viewWithTag(activityIndicatorViewTag) as? UIActivityIndicatorView
  }
  
  private func getOverlayView() -> UIView? {
    viewWithTag(overlayViewTag)
  }
  
}
