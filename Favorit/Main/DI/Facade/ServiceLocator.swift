//
//  ServiceLocator.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Resolver

typealias ServiceLocatorOptions = ResolverOptions

extension ServiceLocatorOptions {
    
    @discardableResult
    func conforms<Protocol>(_ type: Protocol.Type ) -> ServiceLocatorOptions<Service> {
        implements(type)
    }
}

public final class ServiceLocator {
    private init() {}
    
    @discardableResult
    static func register<T>(_ service: @escaping () -> T) -> ServiceLocatorOptions<T> {
        Resolver.main.register(factory: service)
    }
    
    static func resolve<T>() -> T {
        return Resolver.resolve(T.self)
    }
    
    static func registerAllServices() {
        register { NetworkService() }
        registerLoginDependencies()
        registerSignUpDependencies()
        registerUserSession()
        registerFollowDependencies()
        register { UserFollowService() }
        register { FindPlacesService() }
    }
}
