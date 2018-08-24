//
//  CuratedPhotosCollectionViewController.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class CuratedPhotosCollectionViewController: UICollectionViewController {
    
    fileprivate let unsplashCellIdentifier = "UnsplashPhotoCollectionViewCell"
    fileprivate let unsplashArray = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUnsplashCollectionViewCell(cellIdentifier: unsplashCellIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: unsplashCellIdentifier, for: indexPath) as! UnsplashPhotoCollectionViewCell
        let imageString = unsplashArray[indexPath.row]
        cell.unsplashImage.loadImageUsingCacheWithUrlString(urlString: imageString)
        return cell
    }

//Private Methods
    fileprivate func registerUnsplashCollectionViewCell(cellIdentifier: String) {
        let cell = UINib(nibName: cellIdentifier, bundle: nil)
        if let collectionView = collectionView {
            collectionView.register(cell, forCellWithReuseIdentifier: cellIdentifier)
        }
    }

}
