//
//  FeedViewController.swift
//  Favorit
//
//  Created by Abhinay Maurya on 23/12/23.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension FeedViewController {
    static func createViewController() -> FeedViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerName.feedVC.value) as? FeedViewController
    }
}
