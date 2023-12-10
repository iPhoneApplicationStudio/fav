//
//  Follow+Dependencies.swift
//  Favorit
//
//  Created by Amber Katyal on 02/12/23.
//

import Foundation

extension ServiceLocator {
    static func registerFollowDependencies() {
        register { ConcreteFollowingViewModel() }.conforms(FollowingViewModel.self)
        register { NetworkService() }.conforms(FollowingService.self)
    }
}
