//
//  ApplicationCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get }
    
    func start()
    
    var onFinish: (() -> Void)? { get set }
    
    var rootNavigationController: NSViewController { get }
}

class BaseCoordinator: Coordinator {
    
    var children: [Coordinator]
    
    func addChild(_ child: Coordinator) {
        children.append(child)
    }
    
    func removeChild(_ child: Coordinator) {
        let indexToRemove = children.firstIndex { child === $0 }
        
        guard let indexToRemove else {
            assertionFailure("Could not find child to remove")
            return
        }
        
        children.remove(at: indexToRemove)
    }
    
    func start() {}
    
    var onFinish: (() -> Void)?
    
    private(set) var rootNavigationController: NSViewController
    
    init(rootNavigationController: NSViewController) {
        self.rootNavigationController = rootNavigationController
        self.children = []
    }
}

final class ApplicationCoordinator: BaseCoordinator {
    
    var onboardingFlowCompleted: Bool = false
    
    override func start() {
//        if () {
//            startOnboarding()
//        }
//        else if (not authorized) {
//            startAuthorization()
//        }
//        else {
//            startmainflow()
//        }
    }
    
    private func startAuthorization() {
        
    }
    
    private func startOnboarding() {
        let childCoordinator = OnboardingCoordinator(rootNavigationController: rootNavigationController)
        
        self.addChild(childCoordinator)
        
        childCoordinator.onFinish = { [weak self, weak childCoordinator] in
            childCoordinator.map {
                self?.removeChild($0)
            }
            self?.startAuthorization()
        }
        
        childCoordinator.start()
    }
    
    private let serviceLocator: ServiceLocator
    
    init(rootNavigationController: NSViewController, serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        
        super.init(rootNavigationController: rootNavigationController)
    }
    

}
