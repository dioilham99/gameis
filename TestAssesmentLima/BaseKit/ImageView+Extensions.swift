//
//  ImageView+Extensions.swift
//  TestAssesmentLima
//
//  Created by Ilham Hadi P. on 13/02/23.
//

import Foundation
import UIKit

let imageCache = NSCache<NSURL, UIImage>()

class CustomImageView: UIImageView {
  
  var imageURL: String?
  
  func loadImageFromURL(_ urlStr: String) {
    
    imageURL = urlStr
    
    let url = URL(string: urlStr)
    
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: NSURL(string: urlStr)!) {
      self.image = imageFromCache
      return
    }
    
    if let url = url {
      
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
          print(String(describing: error))
          return
        }
        
        DispatchQueue.main.async {
          
          let imageToCache = UIImage(data: data!)?.downsample(reductionAmount: 0.2)
          
          if self.imageURL == urlStr {
            self.image = imageToCache
          }
          
          imageCache.setObject(imageToCache!, forKey: NSURL(string: urlStr)!)
        }
        
      }.resume()
    }
    
    
    
  }
  
  func downsample(imageAt imageURL: URL,
                  to pointSize: CGSize,
                  scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    
    // Create an CGImageSource that represent an image
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
      return nil
    }
    
    // Calculate the desired dimension
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    // Perform downsampling
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
      return nil
    }
    
    // Return the downsampled image as UIImage
    return UIImage(cgImage: downsampledImage)
  }
  
}

extension UIImage {
  
  func downsample(reductionAmount: Float) -> UIImage? {
    let image = UIKit.CIImage(image: self)
    guard let lanczosFilter = CIFilter(name: "CILanczosScaleTransform") else { return nil }
    lanczosFilter.setValue(image, forKey: kCIInputImageKey)
    lanczosFilter.setValue(NSNumber.init(value: reductionAmount), forKey: kCIInputScaleKey)
    
    guard let outputImage = lanczosFilter.outputImage else { return nil }
    let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
    let scaledImage = UIImage(cgImage: context.createCGImage(outputImage, from: outputImage.extent)!)
    
    return scaledImage
  }
  
  
  
}
