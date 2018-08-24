//
//  UnsplashAPI.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation

//unsplash is an online high quality image source
class UnsplashAPI {
    
    struct UnsplashAPI_Constant {
        static fileprivate let clientId = "client_id"
        static fileprivate let clientIdValue = "4943a0f98736e35ebe022865858b1e2fac06652fdf52733c3d6befd5f9f7caa5"
        static let perPageQueryName = "per_page"
        static let imagesPerPage = "30"
        static let page = "page"
        static let unsplashBaseURL = "https://api.unsplash.com"
        static let timeOut = 60.0
        static let applicationJson = "application/json"
        static let accept = "Accept"
        static let getMethod = "GET"
    }
    
    class func retrieveCuratedPhotos(pageNumber: Int, completion: @escaping ([UnsplashImageSource]?, String?)-> Void) {
        let orderBy = "order_by"
        let orderedType = "latest"
        
        let queryItems = [URLQueryItem(name: UnsplashAPI_Constant.clientId, value: UnsplashAPI_Constant.clientIdValue),
                          URLQueryItem(name: UnsplashAPI_Constant.perPageQueryName, value: UnsplashAPI_Constant.imagesPerPage),
                          URLQueryItem(name: orderBy, value: orderedType),
                          URLQueryItem(name: UnsplashAPI_Constant.page, value: String(pageNumber))]
        
        let urlComponent = "/photos/curated"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let urlComps = URLComponents(string: UnsplashAPI_Constant.unsplashBaseURL + urlComponent)
        guard var urlComponents = urlComps else {return}
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {return}
        
        var request = URLRequest(url: url, cachePolicy:.useProtocolCachePolicy, timeoutInterval: UnsplashAPI_Constant.timeOut)
        request.addValue(UnsplashAPI_Constant.applicationJson, forHTTPHeaderField: UnsplashAPI_Constant.accept)
        request.httpMethod = UnsplashAPI_Constant.getMethod
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                    return
                }
            }
            guard let data = data else {
                let errorMessage = "There was an error retrieving the data from Unsplash"
                completion(nil, errorMessage)
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Array<Dictionary<String, Any>> {
                    var unsplashArray = [UnsplashImageSource]()
                    let url = "urls"
                    let imageType = "regular"
                    let user = "user"
                    let fullName = "name"
                    let photoID = "id"
                    DispatchQueue.main.async {
                        for dict in jsonArray {
                            guard let urlDictionary = dict[url] as? Dictionary<String, String> else {continue}
                            guard let unsplashImage = urlDictionary[imageType] else {continue}
                            guard let userDictionary = dict[user] as? Dictionary<String, Any> else {continue}
                            guard let fullName = userDictionary[fullName] as? String else {continue}
                            guard let photoID = dict[photoID] as? String else {continue}
                            
                            let unsplashObject = UnsplashImageSource(imageString: unsplashImage, photograherName: fullName, photoId: photoID)
                            unsplashArray.append(unsplashObject)
                        }
                        completion(unsplashArray, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                    print(error)
                    return
                }
            }
        }
        dataTask.resume()
    }
    
}
