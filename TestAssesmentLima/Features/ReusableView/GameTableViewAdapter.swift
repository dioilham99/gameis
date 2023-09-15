//
//  GameTableViewAdapter.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import Foundation
import UIKit

protocol ScrollViewDelegate: AnyObject {
  
  func didScroll(_ scrollView: UIScrollView)
  
}

protocol FavoriteDelegate: AnyObject {
  func favorite(item: GameViewModel)
}

class GameTableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  weak var scrollViewDelegate: ScrollViewDelegate?
  weak var favoriteDelegate: FavoriteDelegate?
  
  var items: [GameViewModel]
  
  init(items: [GameViewModel]) {
    self.items = items
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollViewDelegate?.didScroll(scrollView)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
    cell.titleView.text = item.title
    cell.releaseDateLabel.text = item.releasedDate
    cell.ratingLabel.text = item.rate
    cell.thumbailImageView.loadImageFromURL(item.image)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    item.tapAction(item.id)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
    return true
  }
  
}
