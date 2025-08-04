import Foundation

struct Profile: Identifiable, Sendable {
    typealias ID = UUID
    
    let id: ID
    let name: String
}

actor ProfileService {
    private var profiles: [Profile.ID: Profile] = [:]
    
    init() {
    }
    
    func profiles() async -> [Profile] {
        Array(profiles.values)
    }
    
    func account(for id: Profile.ID) -> Profile? {
        profiles[id]
    }
    
    func saveProfile(profile: Profile) {
        profiles[profile.id] = profile
    }
}
