//
//  PlacePhotoViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/16/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class PlacePhotoViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var venueId: String?
    var photoURLStrings = [String]()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "VenuePhotoCell", 
                        bundle: nil)
        collectionView.register(nib, 
                                forCellWithReuseIdentifier: "venuePhotoCell")
        if let venueId, photoURLStrings.count == 0 {
            getPhotos(venueId:venueId)
        } else {
            collectionView.reloadData()
        }
    }
    
    func getPhotos(venueId: String) {
        /*print("GET PHOTOS")
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        let service = VenueServices()
        service.getVenuePhotos(venueID: venueId) { (photos, errorCode, errorMessage) in
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            if photos != nil {
                self.photos = photos!
                self.collectionView.reloadData()
            } else {
                print("Photos Error Code \(String(describing: errorCode))")
            }
        }*/
    }
    
}

extension PlacePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        let size = UIScreen.main.bounds.width / 2 - 12
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "venuePhotoCell", for: indexPath) as? VenuePhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.photoURLString = photoURLStrings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "toPhotoVC", sender: indexPath)
    }
}

extension PlacePhotoViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Photos")
    }
}

extension PlacePhotoViewController {
    static func getViewController() -> PlacePhotoViewController? {
        UIStoryboard(name: StoryboardName.main.value,
                     bundle: nil).instantiateViewController(withIdentifier: "placesPhotoVC") as? PlacePhotoViewController
    }
}
