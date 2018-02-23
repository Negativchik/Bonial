//
//  ImageLoader.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 27.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import UIKit

enum ImageLoaderError: Error {
    case badURL
}

typealias ImageDidLoadBlock = (UIImage?, Error?) -> ()

class ImageLoader {
    
    // singleton
    static let shared = ImageLoader()
    
    private var cachedImages = [String: UIImage]()
    private var downloadTasks = [String: URLSessionDownloadTask]()
    
    func fetchImageFrom(urlString: String, onDidLoad completion: @escaping ImageDidLoadBlock) -> URLSessionDownloadTask? {
        // Check if we have cached image
        if let image = cachedImages[urlString] {
            completion(image, nil)
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil, ImageLoaderError.badURL)
            return nil
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { (localURL: URL?, resposnse: URLResponse?, error: Error?) in
            
            defer {
                self.downloadTasks.removeValue(forKey: urlString)
            }
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let localURL = localURL {
                do {
                    let data = try Data.init(contentsOf: localURL)
                    let image = UIImage(data: data)
                    self.cachedImages[urlString] = image
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                    return
                } catch let error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
        downloadTasks[urlString] = downloadTask
        
        downloadTask.resume()
        
        return downloadTask
    }
    
    func purgeCache() {
        cachedImages = [String: UIImage]()
    }
}

class ImageViewLoadHelper {
    static let shared = ImageViewLoadHelper()
    
    private var associatedImageViews = [UIImageView: URLSessionDownloadTask]()
    
    func setImage(urlString: String, imageView: UIImageView) {
        cancelDownload(imageView: imageView)
        
        let downloadTask = ImageLoader.shared.fetchImageFrom(urlString: urlString) { (image: UIImage?, error: Error?) in
            defer {
                self.associatedImageViews.removeValue(forKey: imageView)
            }
            print(urlString)
            if error != nil {
                print(error!)
                return
            }
            if let image = image {
                imageView.image = image
            }
        }
        if let downloadTask = downloadTask {
            ImageViewLoadHelper.shared.associatedImageViews[imageView] = downloadTask
        }
    }
    
    func cancelDownload(imageView: UIImageView) {
        if let task = associatedImageViews[imageView] {
            task.cancel()
            self.associatedImageViews.removeValue(forKey: imageView)
        }
    }
}

extension UIImageView {
    func setImage(urlString: String) {
        ImageViewLoadHelper.shared.setImage(urlString: urlString, imageView: self)
    }
}
