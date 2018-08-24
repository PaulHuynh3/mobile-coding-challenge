//
//  Extensions.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String){
        let imageCache = NSCache<NSString, UIImage>()
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error, #line)
                return
            }
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data){
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        }
        task.resume()
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
