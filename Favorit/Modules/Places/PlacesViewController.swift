//
//  PlacesViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/10/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PlacesViewController: PlacesBaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var addPlaceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        LocationService.sharedInstance.delegate = self
        
        setupTableView()
        setLocationServices()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetails" {
//            let detailController = segue.destination as! PlaceDetailViewController
//            let indexPath = sender as! IndexPath
//            switch indexPath.section {
//            case 0:
//                detailController.savedVenue = getFavoritedVenue(indexPath: indexPath)
//            default:
//                let bookmarkedVenue = getBookmarkedVenue(indexPath: indexPath)
//                if filterMode == FilterMode.followed {
//                    bookmarkedVenue.venueTip = nil
//                }
//                detailController.savedVenue = bookmarkedVenue
//            }
//        }
    }
}


