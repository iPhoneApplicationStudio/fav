//
//  FindUsersViewController+Factory.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation
import UIKit

extension FindUsersViewController {
    
    static func makeFindUsersViewController() -> FindUsersViewController {
        let storyboard = UIStoryboard(name: "FindUsersViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FindUsersViewController") as! FindUsersViewController
        return vc
    }
}
