import Foundation

struct DeveloperAccount: Identifiable, Sendable {
    typealias ID = UUID
    
    let id: ID
    let name: String
}

actor ProfileService {
    private var profiles: [DeveloperAccount.ID: DeveloperAccount] = [:]
    
    init() {
    }
    
    func profiles() async -> [DeveloperAccount] {
        Array(profiles.values)
    }
    
    func account(for id: DeveloperAccount.ID) -> DeveloperAccount? {
        profiles[id]
    }
    
    func saveProfile(profile: DeveloperAccount) {
        profiles[profile.id] = profile
    }
}

import ComposableArchitecture

enum ViewType: String, CaseIterable {
    case reviews = "Reviews"
    case appInfo = "App Info"
}
