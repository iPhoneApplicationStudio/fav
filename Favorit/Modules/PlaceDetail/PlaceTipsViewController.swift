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

class PlaceTipsViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noTipsMessageLabel: UILabel!
    
    var primaryTip: TipRecord?
    var venueId: String?
    var venueTips: [TipRecord]?
    
    weak var delegate: SegueHandlerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTipsView()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toComposeTips" {
//            let detailVC = parent as! PlaceDetailViewController
//            let composeVC = segue.destination as! ComposeTipViewController
//            composeVC.favoritVenue = detailVC.favoritVenue
//        }
    }
}

private extension PlaceTipsViewController {
    //MARK: Set UI
    func setTipsView() {
        self.getTips()
    }
    
    func resetTipsArray() {
        if venueTips?.count ?? 0 > 0 {
            venueTips?.removeAll()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 66,
                                              right: 0)
        tableView.tableFooterView = UIView()
        tableView.layer.masksToBounds = false
    }
    
    func setNoTipUI() {
        self.noTipsMessageLabel.text = setNoTipsLabel()
        self.noTipsMessageLabel.isHidden = false
        self.tableView.isHidden = true
        UIView.animate(withDuration: 1.5, animations: {
            self.noTipsMessageLabel.alpha = 1.0
        })
    }
    
    func setNoTipsLabel() -> String {
        return TipsEmptyResultsStrings.loggedIn
    }
    
    //MARK: Notification Center
    @objc func userDidSignIn(_ notification:Notification) {
        resetViews()
        setTipsView()
    }
    
    func resetViews() {
        self.tableView.isHidden = true
        self.noTipsMessageLabel.isHidden = true
        self.noTipsMessageLabel.alpha = 0
    }
    
    //MARK: Tip Management
    func getTips(){
        guard let venueId = venueId else {
            setNoTipUI()
            return
        }
        
        /*activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        let services = VenueServices()
        services.getTips(venueId: venueId) { (venueTips, error) in
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            
            if error == nil {
                if venueTips?.count == 0 && self.primaryTip == nil {
                    
                    self.setNoTipUI()
                } else {
                    guard var venueTipsArray = venueTips else {return}
                    if let tip = self.primaryTip {
                        venueTipsArray.insert(tip, at: 0)
                    }
                    self.venueTips = Array(NSOrderedSet(array: venueTipsArray)) as? [VenueTips]
                    self.tableView.reloadData()
                    self.fadeInView(view: self.tableView)
                }
            } else {
                self.showError(message: (error?.localizedDescription)!)
            }
        }*/
    }
}

//MARK: UITableView Delegate & DataSource
extension PlaceTipsViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = venueTips?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipsCell") as! TipsCell
        cell.venueTip = venueTips?[indexPath.section]
//        print("primary TIP Cell \(venueTips?[indexPath.section].tip)")
        
        cell.tipTextView.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedUserID = venueTips?[indexPath.section].tipUserId else {return}
//        delegate?.segueToProfile(identifier: "toUserProfile", sender: selectedUserID)
    }
}

//MARK: UITextViewDelegate
extension PlaceTipsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        delegate?.segueToProfile(identifier: "toWebVC", sender: URL)
        return false
    }
}

extension PlaceTipsViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notes")
    }
}

extension PlaceTipsViewController {
    static func getViewController() -> PlaceTipsViewController? {
        return UIStoryboard(name: StoryboardName.main.value,
                            bundle: nil).instantiateViewController(withIdentifier: "placesTipsVC") as? PlaceTipsViewController
    }
}
