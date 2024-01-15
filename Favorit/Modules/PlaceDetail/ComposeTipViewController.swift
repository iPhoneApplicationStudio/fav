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

protocol ComposeTipViewDelegate: AnyObject {
    func bookmarkedStateChangedFor(state: Bool)
}

class ComposeTipViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tipTextView: UITextView!
    @IBOutlet weak var tipDoneButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var viewModel: ComposeNoteProtocol?
    weak var composeTipViewDelegate: ComposeTipViewDelegate?
    
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
        self.initialSetting()
    }
    
    //MARK: Private Methods
    private func initialSetting() {
        tipDoneButton.layer.cornerRadius = tipDoneButton.frame.height / 2
        tipDoneButton.clipsToBounds = true
        
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
    
    private func isValidTip() -> Bool {
        if isEditMode {
            return true
        }
        
        if !didBeginEditing || tipTextView.text.isEmpty || tipTextView.text == placeholderText {
            return false
        }
        return true
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
        }
    }
    
    private func stopActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    private func bookmarkedTheVenue() {
        guard let viewModel else {
            return
        }
        
        viewModel.addToBookmark {[weak self] result in
            self?.stopActivityIndicator()
            guard let result else {
                return
            }
            
            switch result {
            case .success(let flag):
                if !flag {
                    self?.showError(message: viewModel.errorMessage)
                } else {
                    self?.composeTipViewDelegate?.bookmarkedStateChangedFor(state: true)
                }
                
            case.failure(let error):
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    private func saveTheNote() {
        guard let viewModel,
              let note = tipTextView.text else {
            return
        }
        
        self.showActivityIndicator()
        viewModel.saveNote(note: note) {[weak self] result in
            guard let result else {
                self?.stopActivityIndicator()
                return
            }
            
            switch result {
            case .success(let flag):
                if !flag {
                    self?.stopActivityIndicator()
                    self?.showError(message: viewModel.errorMessage)
                } else {
                    self?.bookmarkedTheVenue()
                }
                
            case.failure(let error):
                self?.stopActivityIndicator()
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.startActivityIndicator()
        self.saveTheNote()
    }
}

private extension ComposeTipViewController {
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
    static func getViewController(viewModel: ComposeNoteProtocol) -> ComposeTipViewController? {
        let composeTipViewController = UIStoryboard(name: StoryboardName.main.value,
                            bundle: nil).instantiateViewController(withIdentifier: "composeTipsVC") as? ComposeTipViewController
        composeTipViewController?.viewModel = viewModel
        return composeTipViewController
    }
}
