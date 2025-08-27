import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {

    @Published var profile: UserProfile = UserProfile()
    @Published var isLoading = false
    @Published var isUpdating = false
    @Published var errorMessage: String?
    @Published var showSuccessMessage = false
    
   
    private let profileService: ProfileServiceProtocol
    
  
    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
        Task {
            await loadProfile()
        }
    }
    
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        let loadedProfile = await profileService.loadProfile()
        self.profile = loadedProfile
        
        isLoading = false
    }
    
    func updateProfile(_ newProfile: UserProfile) async -> Bool {
        isUpdating = true
        errorMessage = nil
        showSuccessMessage = false
        
        let result = await profileService.updateProfile(newProfile)
        
        switch result {
        case .success:
            self.profile = newProfile
            showSuccessMessage = true
            isUpdating = false
            return true
            
        case .failure(let error):
            errorMessage = error.localizedDescription
            isUpdating = false
            return false
        }
    }
    
    func resetToDefault() async -> Bool {
        isUpdating = true
        errorMessage = nil
        
        let result = await profileService.resetToDefault()
        
        switch result {
        case .success:
            self.profile = UserProfile.defaultProfile
            showSuccessMessage = true
            isUpdating = false
            return true
            
        case .failure(let error):
            errorMessage = error.localizedDescription
            isUpdating = false
            return false
        }
    }
    
    func validateProfile(_ profileToValidate: UserProfile) -> String? {
        if let error = profileService.validateProfile(profileToValidate) {
            return error.localizedDescription
        }
        return nil
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func clearSuccessMessage() {
        showSuccessMessage = false
    }
}


@MainActor
class EditProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var tempProfile: UserProfile
    @Published var isUpdating = false
    @Published var validationError: String = ""
    @Published var showingSaveAlert = false
    @Published var showingResetAlert = false
    @Published var showingErrorAlert = false
    
   
    private let profileViewModel: ProfileViewModel
    
   
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        self.tempProfile = profileViewModel.profile
    }
    
   
    func saveProfile() async -> Bool {
        validationError = ""
        
        if let error = profileViewModel.validateProfile(tempProfile) {
            validationError = error
            return false
        }
        
        isUpdating = true
        let success = await profileViewModel.updateProfile(tempProfile)
        isUpdating = false
        
        if success {
            showingSaveAlert = true
        } else {
            showingErrorAlert = true
        }
        
        return success
    }
    
    func resetProfile() async {
        isUpdating = true
        _ = await profileViewModel.resetToDefault()
        tempProfile = profileViewModel.profile
        isUpdating = false
    }
    
    func updateTempProfile(_ newProfile: UserProfile) {
        tempProfile = newProfile
        validationError = ""
    }
    
    var errorMessage: String? {
        return profileViewModel.errorMessage
    }
}
