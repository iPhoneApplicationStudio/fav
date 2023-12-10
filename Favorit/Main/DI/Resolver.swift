//
//  Resolver.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        ServiceLocator.registerAllServices()
    }
}
