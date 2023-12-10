//
//  FindUsersViewController+Factory.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import UIKit

extension FindUsersViewController {
    static func makeFindUsersViewController() -> FindUsersViewController? {
        let storyboard = UIStoryboard(name: "FindUsersViewController",
                                      bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FindUsersViewController") as? FindUsersViewController else {
            return nil
        }
        
        vc.viewModel = FindUsersViewModel()
        return vc
    }
}
