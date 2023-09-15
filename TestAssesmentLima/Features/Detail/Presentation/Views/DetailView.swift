//
//  DetailView.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 12/02/23.
//

import UIKit

class DetailView: UIView {
 
  @IBOutlet weak var bannerImageView: CustomImageView!
  
  @IBOutlet weak var developerLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var releaseDateLabel: UILabel!
  
  @IBOutlet weak var ratingLabel: UILabel!
  
  @IBOutlet weak var playedLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func setData(_ data: GameDetailViewModel){
    developerLabel.text = data.developerName
    titleLabel.text = data.title
    releaseDateLabel.text = data.releaseDate
    ratingLabel.text = data.ratingStr
    playedLabel.text = data.played
    descriptionLabel.text = data.description
    bannerImageView.loadImageFromURL(data.image)
  }
  
}
