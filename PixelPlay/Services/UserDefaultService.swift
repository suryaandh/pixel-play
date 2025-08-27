import Foundation

protocol UserDefaultsServiceProtocol {
    func saveProfile(_ profile: UserProfile) async throws
    func loadProfile() async -> UserProfile
    func resetToDefault() async throws
    func clearProfile() async throws
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    
    private enum Keys {
        static let userName = "user_name"
        static let userEmail = "user_email"
        static let userPhone = "user_phone"
        static let userImageURL = "user_image_url"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveProfile(_ profile: UserProfile) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            userDefaults.set(profile.name, forKey: Keys.userName)
            userDefaults.set(profile.email, forKey: Keys.userEmail)
            userDefaults.set(profile.phone, forKey: Keys.userPhone)
            userDefaults.set(profile.imageURL, forKey: Keys.userImageURL)
        }
    }
    
    func loadProfile() async -> UserProfile {
        return await MainActor.run {
            UserProfile(
                name: userDefaults.string(forKey: Keys.userName) ?? UserProfile.defaultProfile.name,
                email: userDefaults.string(forKey: Keys.userEmail) ?? UserProfile.defaultProfile.email,
                phone: userDefaults.string(forKey: Keys.userPhone) ?? UserProfile.defaultProfile.phone,
                imageURL: userDefaults.string(forKey: Keys.userImageURL) ?? UserProfile.defaultProfile.imageURL
            )
        }
    }
    
    func resetToDefault() async throws {
        try await saveProfile(UserProfile.defaultProfile)
    }
    
    func clearProfile() async throws {
        await MainActor.run {
            userDefaults.removeObject(forKey: Keys.userName)
            userDefaults.removeObject(forKey: Keys.userEmail)
            userDefaults.removeObject(forKey: Keys.userPhone)
            userDefaults.removeObject(forKey: Keys.userImageURL)
        }
    }
}

// MARK: - UserDefaults Extensions (for backward compatibility)
extension UserDefaults {
    var userName: String {
        get { string(forKey: "user_name") ?? UserProfile.defaultProfile.name }
        set { set(newValue, forKey: "user_name") }
    }
    
    var userEmail: String {
        get { string(forKey: "user_email") ?? UserProfile.defaultProfile.email }
        set { set(newValue, forKey: "user_email") }
    }
    
    var userPhone: String {
        get { string(forKey: "user_phone") ?? UserProfile.defaultProfile.phone }
        set { set(newValue, forKey: "user_phone") }
    }
    
    var userImageURL: String {
        get { string(forKey: "user_image_url") ?? UserProfile.defaultProfile.imageURL }
        set { set(newValue, forKey: "user_image_url") }
    }
}
