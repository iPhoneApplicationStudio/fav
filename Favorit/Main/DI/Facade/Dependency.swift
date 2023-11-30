//
//  Dependency.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import Resolver

@propertyWrapper
public struct Dependency<Service> {
    
    private var service: Service
    
    public init() {
        self.service = Resolver.resolve(Service.self)
    }
    
    public init(name: Resolver.Name? = nil, 
                container: Resolver? = nil) {
        self.service = container?.resolve(Service.self, name: name) ?? Resolver.resolve(Service.self, name: name)
    }
    
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: Dependency<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}
