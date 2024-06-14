//
//  ServiceLocator.swift
//  AppStoreConnectKit
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation

public protocol ServiceLocator {
    func resolve<T>() -> T
    func resolve<T>(_ type: T.Type) -> T
}

public final class ServiceLocatorImpl: ServiceLocator {
    
    public init() {}
    
    private var services = [String: Any]()
    
    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    public func register<T>(service: T, type: T.Type) {
        let key = typeName(type)
        services[key] = service
    }

    public func resolve<T>() -> T {
        let key = typeName(T.self)
        guard let service = services[key] as? T else {
            preconditionFailure("Missing registered service")
        }
        return service
    }
    
    public func resolve<T>(_ type: T.Type) -> T {
        let key = typeName(T.self)
        guard let service = services[key] as? T else {
            preconditionFailure("Missing registered service for name: \(key)")
        }
        return service
    }
}
