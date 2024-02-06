//
//  FeedViewController.swift
//
//  Created by Chris Piazza on 12/19/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit
import SideMenu

protocol TimelineCellDelegate {
    func timelineActionLabelTapped(isUserTapped: Bool, tag: Int)
}

class FeedViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notFollowingLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    //MARK: Properties
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshScreen), for: .valueChanged)
        return refreshControl
    }()
    
//    var timeline = [UserTimeline]()
//    let actionTypes = ActionType.allCases 
//    var filterDataArray: FilterData!
//    var filterSelectedArray: FilterData?
    
    var firstRowSelected = true
    var viewModel: FeedActivityProtocol?
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Private methods
    private func initialSetting() {
        //TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        self.tableView.addSubview(refreshControl)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.white
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    private func loadData() {
        guard let viewModel else {
            return
        }
        
        self.activityIndicatorView.start()
        viewModel.fetchData {[weak self] result in
            self?.activityIndicatorView.stop()
            switch result {
            case .success(let flag):
                break
            case .failure(let error):
                break
            }
        }
        
    }
    
    @objc private func refreshScreen() {
        self.loadData()
    }
}

private extension FeedViewController {
    func handleResultsUI(isFilter: Bool) {
//        if self.timeline.count == 0 {
//            setEmptyResultsLabel(isFilter: isFilter)
//            self.notFollowingLabel.isHidden = false
//            self.tableView.isHidden = true
//        } else {
//            if !self.notFollowingLabel.isHidden {
//                self.notFollowingLabel.isHidden = true
//                self.tableView.isHidden = false
//            }
//            self.tableView.reloadData()
//        }
    }
    
    func setEmptyResultsLabel(isFilter: Bool) {
        if isFilter {
            self.notFollowingLabel.text = FeedEmptyResultsStrings.filterEmpty
        } else {
            self.notFollowingLabel.text = FeedEmptyResultsStrings.noFeedResults
        }
    }
    
    //MARK: IBAction
    @IBAction func filterButtonPressed(_ sender: Any) {
        //        filterButtonPressed()
    }
}

extension FeedViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let userTimeline = timeline[indexPath.row]
//        guard let actionType = ActionType(rawValue: userTimeline.timelineType!) else {return UITableViewCell()}
//        print("ACTION TYPE \(actionType)")
//        switch actionType {
//        case .news:
//            if let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as? NewsFeedCell {
//                newsCell.timeline = userTimeline
//                newsCell.delegate = self
//                newsCell.tag = indexPath.row
//                newsCell.urlLinkTextView.delegate = self
//                return newsCell
//            }
//        default:
//            if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as? TimelineCell {
//                timelineCell.timeline = userTimeline
//                timelineCell.delegate = self
//                timelineCell.tag = indexPath.row
//                return timelineCell
//            }
//        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DidSelectRow")
    }
}

extension FeedViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        //        UIApplication.shared.open(URL, options: [:])
        performSegue(withIdentifier: "toWebVC", sender: URL)
        
        return false
    }
}

extension FeedViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }
        return true
    }
}

extension FeedViewController {
    public static func createViewController(viewModel: FeedActivityProtocol) -> FeedViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerName.feedVC.value) as? FeedViewController
        vc?.viewModel = viewModel
        return vc
    }
}

