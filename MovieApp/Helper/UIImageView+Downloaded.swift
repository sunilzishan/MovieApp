//
//  UIImageView+Downloaded.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import Foundation
import UIKit

class DownloadingImageView: UIImageView {
    let imageCache = NSCache<NSString, UIImage>()
    var imageURLString: String?
    func loadImage(urlString: String) {
        imageURLString = urlString
        let url = URL(string: urlString)!
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error as Any)
            }
            DispatchQueue.main.async { [self] in
                var imageToCache = UIImage()
                if let downloadedImage = UIImage(data: data!) {
                    if imageURLString == urlString {
                        imageToCache = downloadedImage
                    }
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}
