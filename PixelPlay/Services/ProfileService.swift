import Foundation

protocol ProfileServiceProtocol {
    func loadProfile() async -> UserProfile
    func updateProfile(_ profile: UserProfile) async -> ProfileUpdateResult
    func resetToDefault() async -> ProfileUpdateResult
    func validateProfile(_ profile: UserProfile) -> ProfileError?
}

class ProfileService: ProfileServiceProtocol {
    
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    init(userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.userDefaultsService = userDefaultsService
    }
    
    func loadProfile() async -> UserProfile {
        return await userDefaultsService.loadProfile()
    }
    
    func updateProfile(_ profile: UserProfile) async -> ProfileUpdateResult {
       
        if let validationError = validateProfile(profile) {
            return .failure(validationError)
        }
        
        do {
            try await userDefaultsService.saveProfile(profile)
            return .success
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
    
    func resetToDefault() async -> ProfileUpdateResult {
        do {
            try await userDefaultsService.resetToDefault()
            return .success
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
    
    func validateProfile(_ profile: UserProfile) -> ProfileError? {
        let trimmedName = profile.name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = profile.email.trimmingCharacters(in: .whitespaces)
        let trimmedPhone = profile.phone.trimmingCharacters(in: .whitespaces)
        
        if trimmedName.isEmpty {
            return .emptyName
        }
        
        if trimmedEmail.isEmpty {
            return .emptyEmail
        }
        
        if !profile.isValidEmail {
            return .invalidEmail
        }
        
        if trimmedPhone.isEmpty {
            return .emptyPhone
        }
        
        return nil
    }
}

class MockProfileService: ProfileServiceProtocol {
    var shouldFailUpdate = false
    var shouldFailValidation = false
    var mockProfile = UserProfile.defaultProfile
    
    func loadProfile() async -> UserProfile {
        return mockProfile
    }
    
    func updateProfile(_ profile: UserProfile) async -> ProfileUpdateResult {
        if shouldFailUpdate {
            return .failure(.networkError("Mock network error"))
        }
        
        if let validationError = validateProfile(profile) {
            return .failure(validationError)
        }
        
        mockProfile = profile
        return .success
    }
    
    func resetToDefault() async -> ProfileUpdateResult {
        if shouldFailUpdate {
            return .failure(.networkError("Mock network error"))
        }
        
        mockProfile = UserProfile.defaultProfile
        return .success
    }
    
    func validateProfile(_ profile: UserProfile) -> ProfileError? {
        if shouldFailValidation {
            return .invalidEmail
        }
        
        let trimmedName = profile.name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = profile.email.trimmingCharacters(in: .whitespaces)
        let trimmedPhone = profile.phone.trimmingCharacters(in: .whitespaces)
        
        if trimmedName.isEmpty {
            return .emptyName
        }
        
        if trimmedEmail.isEmpty {
            return .emptyEmail
        }
        
        if !profile.isValidEmail {
            return .invalidEmail
        }
        
        if trimmedPhone.isEmpty {
            return .emptyPhone
        }
        
        return nil
    }
}
