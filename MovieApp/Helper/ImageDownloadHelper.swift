//
//  ImageDownloadHelper.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import Foundation
import UIKit

protocol ImageDownloadHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ())
}

class ImageDownloadHelper: ImageDownloadHelperProtocol {
    let urlSession: URLSession = URLSession.shared

    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(UIImage(data: data), response, error)
            } else {
                completion(nil, response, error)
            }
        }.resume()
    }
}

