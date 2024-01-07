//
//  ComposeTipViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 1/5/18.
//  Copyright © 2018 Bushman Studio. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class ComposeTipViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tipTextView: UITextView!
    @IBOutlet weak var tipDoneButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var place: Place? {
        didSet{
            setPlaceholderText()
        }
    }
    
//    var venueTip: VenueTips?
    private var placeholderText: String?
    private var didBeginEditing = false
    
    var isEditMode = false

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneButton()
        setupTextView()
    }
    
    func isValidTip() -> Bool {
        if isEditMode {
            return true
        }
        if !didBeginEditing || tipTextView.text.isEmpty || tipTextView.text == placeholderText {
            return false
        }
        return true
    }
    
}

private extension ComposeTipViewController {
    //MARK: Setup UI
    func setupDoneButton() {
        tipDoneButton.layer.cornerRadius = tipDoneButton.frame.height / 2
        tipDoneButton.clipsToBounds = true
    }
    
    func setupTextView() {
        tipTextView.delegate = self
        tipTextView.layer.cornerRadius = 5.0
        tipTextView.layer.borderWidth = 1.0
        tipTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        if isEditMode {
//            tipTextView.text = venueTip?.tip
        } else {
            tipTextView.text = placeholderText
            tipTextView.textColor = UIColor.lightGray
        }
    }
    
    func setPlaceholderText() {
        var venueNameString = "this venue"
        if let venueName = place?.name {
            venueNameString = venueName
        }
        
        self.placeholderText = "Click here to add a note about \(venueNameString) before you bookmark (280 Characters)"
    }
    
//    private func saveTip(objectArray: [PFObject]) {
//        /*let services = VenueServices()
//        services.saveVenueAndTip(objectArray: objectArray, type: Constants.VenueRelationType.bookmarkRelation, onCompletion: { (success, error) in
//            self.activityIndicatorView.isHidden = true
//            self.activityIndicatorView.stopAnimating()
//            if success {
//                self.navigationController?.setNavigationBarHidden(false, animated: false)
//                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//                print("viewcontrollers COUNT \(viewControllers.count)")
//                self.navigationController!.popToViewController(viewControllers[0], animated: true)
//            } else {
//                self.showError(message: "ERROR: DID NOT SAVE \(error!.localizedDescription)")
//            }
//        })*/
//    }
    
    private func bookmarkedTheVenue() {
        /*guard let venue = favoritVenue else {
            self.showError(message: "Oops, something went wrong. Please try again")
            return
        }
        var objectArray = [] as! [PFObject]
        if isEditMode {
            self.venueTip?.tip = tipTextView.text
            objectArray = [self.venueTip] as! [PFObject]
        } else {
//             var tipString = "On my to-do list"
            var tipString = ""

            if isValidTip() {
                tipString = tipTextView.text
            }
            let params: [String:String] = [
                "venueTip"  : tipString,
                "venueId"   : venue.venueId!,
                "venueName" : venue.name!]
            let newVenueTip = VenueTips(tip: params)
            FavoritUser.current()?.incrementKey("bookmarksCount", byAmount: 1)
            venue.incrementKey(Constants.VenueRelationType.bookmarkRelation, byAmount: 1)
            let savedVenue = SavedVenue(favoritVenue: venue, venueTip: newVenueTip, isFavorit: false)
            objectArray = [newVenueTip, savedVenue, venue]
        }
         
        saveTip(objectArray: objectArray)*/
    }
    
    //MARK: IBAction
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        self.bookmarkedTheVenue()
    }
}

//MARK: TextView Delegate
extension ComposeTipViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, 
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 280
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            didBeginEditing = true
            textView.text = nil
            textView.textColor = .primaryColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}

extension ComposeTipViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bookmark")
    }
}

extension ComposeTipViewController {
    static func getViewController() -> ComposeTipViewController? {
        return UIStoryboard(name: StoryboardName.main.value,
                            bundle: nil).instantiateViewController(withIdentifier: "composeTipsVC") as? ComposeTipViewController
    }
}
