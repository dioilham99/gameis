//
//  GameTableViewCell.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
  
  static let nib = UINib(nibName: String(describing: GameTableViewCell.self), bundle: nil)
  static let identifier = String(describing: GameTableViewCell.self)
  
  @IBOutlet weak var thumbailImageView: CustomImageView!
  
  @IBOutlet weak var titleView: UILabel!
  
  @IBOutlet weak var releaseDateLabel: UILabel!
  
  @IBOutlet weak var ratingLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    thumbailImageView.layer.cornerRadius = 5
    thumbailImageView.clipsToBounds = true
    
  }

}
