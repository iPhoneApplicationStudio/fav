//
//  PlaceTipsViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/16/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import MapKit
import XLPagerTabStrip
import NVActivityIndicatorView

class NotesViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noTipsMessageLabel: UILabel!
    
    //MARK: Properties
    var viewModel: NotesProtocol?
    weak var delegate: SegueHandlerDelegate?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "toComposeTips" {
        //            let detailVC = parent as! PlaceDetailViewController
        //            let composeVC = segue.destination as! ComposeTipViewController
        //            composeVC.favoritVenue = detailVC.favoritVenue
        //        }
    }
    
    //MARK: Private methods
    func initialSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 66,
                                              right: 0)
        tableView.tableFooterView = UIView()
        tableView.layer.masksToBounds = false
        self.fetchNotes()
    }
    
    private func fetchNotes() {
        guard let viewModel else {
            self.setNoTipUI()
            return
        }
        
        self.startActivityIndicator()
        viewModel.fetchNotes {[weak self] result in
            self?.stopActivityIndicator()
            guard let result else {
                return
            }
            
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        self?.showError(message: (errorMessage))
                    }
                }
            case .failure(let error):
                self?.setNoTipUI()
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    private func reloadScreen() {
        DispatchQueue.main.async {[weak self] in
            let totalNotes = self?.viewModel?.numberOfNotes ?? 0
            totalNotes > 0 ? self?.tableView.reloadData() : self?.setNoTipUI()
        }
    }
    
    private func setNoTipUI() {
        DispatchQueue.main.async {[weak self] in
            self?.noTipsMessageLabel.text = self?.setNoTipsLabel()
            self?.noTipsMessageLabel.isHidden = false
            self?.tableView.isHidden = true
            UIView.animate(withDuration: 1.5, animations: {
                self?.noTipsMessageLabel.alpha = 1.0
            })
        }
    }
    
    private func setNoTipsLabel() -> String {
        return TipsEmptyResultsStrings.loggedIn
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
}

//MARK: UITableView Delegate & DataSource
extension NotesViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection
                   section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel else {
            return 0
        }
        
        return viewModel.numberOfNotes
    }
    
    func tableView(_ tableView: UITableView, 
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: "tipsCell") as? TipsCell else {
            return UITableViewCell()
        }
        
        cell.note = viewModel.noteFor(index: indexPath.section)
        cell.tipTextView.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
//        guard let selectedUserID = venueTips?[indexPath.section].tipUserId else {return}
//        delegate?.segueToProfile(identifier: "toUserProfile", sender: selectedUserID)
    }
}

//MARK: UITextViewDelegate
extension NotesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        delegate?.segueToProfile(identifier: "toWebVC", sender: URL)
        return false
    }
}

//MARK: Other
extension NotesViewController {
    static func getViewController(placeID: String?) -> NotesViewController? {
        let viewModel = NotesViewModel(placeID: placeID)
        let notesViewController = UIStoryboard(name: StoryboardName.main.value,
                            bundle: nil).instantiateViewController(withIdentifier: "placesTipsVC") as? NotesViewController
        notesViewController?.viewModel = viewModel
        return notesViewController
    }
}

extension NotesViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notes")
    }
}
