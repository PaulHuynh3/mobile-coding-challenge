//
//  DetailedPhotoViewController.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedPhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    var unsplashArray: [UnsplashImageSource]!
    var initialImageIndex: Int?
    var photographerName: String?
    var lastPhotoPositionDelegate: LastPhotoPositionDelegate?
    var currentImageIndex: Int?
    
    fileprivate let unsplashCellIdentifier = "UnsplashPhotoCollectionViewCell"
    
    override func viewDidLayoutSubviews() {
        registerUnsplashCollectionViewCell(cellIdentifier: unsplashCellIdentifier)
        if let initialImageIndex = initialImageIndex {
            guard let collectionView = collectionView else {return}
            collectionView.scrollToItem(at: IndexPath(item: initialImageIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.initialImageIndex = nil
        }
    }
    
    fileprivate func registerUnsplashCollectionViewCell(cellIdentifier: String) {
        let cell = UINib(nibName: cellIdentifier, bundle: nil)
        if let collectionView = collectionView {
            collectionView.register(cell, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    @IBAction func exitFullScreenTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if let currentImageIndex = currentImageIndex {
            lastPhotoPositionDelegate?.scrollToCurrentIndex(currentImageIndex)
        }
    }
}

extension DetailedPhotoViewController: UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: unsplashCellIdentifier, for: indexPath) as! UnsplashPhotoCollectionViewCell
        let unsplashItem = unsplashArray[indexPath.row]
        nameLabel.text = unsplashItem.photographerName
        currentImageIndex = indexPath.row
        cell.unsplashImage.loadImageUsingCacheWithUrlString(urlString: unsplashItem.imageString)
        return cell
    }
}

extension DetailedPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeForItem = CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        return sizeForItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
