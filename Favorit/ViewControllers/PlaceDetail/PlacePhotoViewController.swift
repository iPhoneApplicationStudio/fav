//
//  PlacePhotoViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/16/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import Lightbox
import XLPagerTabStrip
import NVActivityIndicatorView

class PlacePhotoViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var viewModel: PlacePhotoProtocol?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: VenuePhotoCell.identifier,
                        bundle: nil)
        self.collectionView.register(nib,
                                forCellWithReuseIdentifier: VenuePhotoCell.identifier)
    }
}

extension PlacePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        return viewModel.numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = UIScreen.main.bounds.width / 2 - 12
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VenuePhotoCell.identifier,
                                                            for: indexPath) as? VenuePhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.photoURLString = viewModel.photoURLFor(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        guard let viewModel,
              let lightBoxImages = viewModel.getAllLightBoxImages() else {
            return
        }
        
        let controller = LightboxController(images: lightBoxImages,
                                            startIndex: indexPath.item)
        controller.dynamicBackground = true
        self.present(controller, animated: true, completion: nil)
    }
}

extension PlacePhotoViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Photos")
    }
}

extension PlacePhotoViewController {
    static func getViewController(photoURLStrings: [String]?) -> PlacePhotoViewController? {
        let placePhotoViewController = UIStoryboard(name: StoryboardName.main.value,
                     bundle: nil).instantiateViewController(withIdentifier: "placesPhotoVC") as? PlacePhotoViewController
        placePhotoViewController?.viewModel = PlacePhotoViewModel(photoURLs: photoURLStrings)
        return placePhotoViewController
    }
}
