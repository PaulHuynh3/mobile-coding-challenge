//
//  CuratedPhotosCollectionViewController.swift
//  Unsplash-coding-challenge
//
//  Created by Paul on 2018-08-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

protocol LastPhotoPositionDelegate {
    func scrollToCurrentIndex(_ currentIndex: Int)
}

class CuratedPhotosCollectionViewController: UICollectionViewController {
    fileprivate let unsplashCellIdentifier = "UnsplashPhotoCollectionViewCell"
    fileprivate var unsplashArray = [UnsplashImageSource]()
    var currentPageNumber = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUnsplashCollectionViewCell(cellIdentifier: unsplashCellIdentifier)
        retrieveCuratedPhotos(currentPageNumber)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: unsplashCellIdentifier, for: indexPath) as! UnsplashPhotoCollectionViewCell
        let imageString = unsplashArray[indexPath.row].imageString
        cell.unsplashImage.loadImageUsingCacheWithUrlString(urlString: imageString)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboardName = "Main"
        let storyboardId = "DetailedPhotoViewController"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let detailedPhotoCollectionViewController = storyboard.instantiateViewController(withIdentifier: storyboardId) as! DetailedPhotoViewController
        detailedPhotoCollectionViewController.unsplashArray = unsplashArray
        detailedPhotoCollectionViewController.initialImageIndex = indexPath.row
        detailedPhotoCollectionViewController.lastPhotoPositionDelegate = self
        self.present(detailedPhotoCollectionViewController, animated: false)
    }

    // MARK: Private Methods
    fileprivate func registerUnsplashCollectionViewCell(cellIdentifier: String) {
        let cell = UINib(nibName: cellIdentifier, bundle: nil)
        if let collectionView = collectionView {
            collectionView.register(cell, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    fileprivate func retrieveCuratedPhotos(_ pageNumber: Int) {
        UnsplashAPI.retrieveCuratedPhotos(pageNumber: pageNumber) { [weak self] (unsplashArray: [UnsplashImageSource]?, error: String?) in
            guard let strongSelf = self else {return}
            if let error = error {
                let errorTitle = "Error"
                let actionTitle = "OK"
                strongSelf.showAlert(title: errorTitle, message: error, actionTitle: actionTitle)
                return
            }
            if let unsplashObjects = unsplashArray {
                strongSelf.unsplashArray += unsplashObjects
            }
            strongSelf.collectionView?.reloadData()
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension CuratedPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageHeight: CGFloat = 230
        let itemsPerRow: CGFloat = 2
        let sizeForItem = CGSize(width: collectionView.bounds.size.width/itemsPerRow, height: imageHeight)
        return sizeForItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: UIScrollViewDelegate
extension CuratedPhotosCollectionViewController {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            processScrollInScrollView(scrollView)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        processScrollInScrollView(scrollView)
    }
    
    fileprivate func processScrollInScrollView(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if bottomEdge >= scrollView.contentSize.height {
            loadNextScreen(scrollView: scrollView)
        }
    }
    
    fileprivate func loadNextScreen(scrollView: UIScrollView) {
        //we are at the bottom of the screen
        currentPageNumber = currentPageNumber + 1
        retrieveCuratedPhotos(currentPageNumber)
    }
}

extension CuratedPhotosCollectionViewController: LastPhotoPositionDelegate {

    func scrollToCurrentIndex(_ currentIndex: Int) {
        collectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .top, animated: true)
    }

}
