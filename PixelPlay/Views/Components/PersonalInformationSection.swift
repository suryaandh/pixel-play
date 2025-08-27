import SwiftUI

struct PersonalInformationSection: View {
    let profile: UserProfile
    let onProfileChange: (UserProfile) -> Void
    
    @State private var tempName: String
    @State private var tempEmail: String
    @State private var tempPhone: String
    
    init(profile: UserProfile, onProfileChange: @escaping (UserProfile) -> Void) {
        self.profile = profile
        self.onProfileChange = onProfileChange
        self._tempName = State(initialValue: profile.name)
        self._tempEmail = State(initialValue: profile.email)
        self._tempPhone = State(initialValue: profile.phone)
    }
    
    var body: some View {
        Section(
            content: {
                ProfileFieldView(
                    label: "Name",
                    text: $tempName,
                    keyboardType: .default,
                    autocapitalization: .words,
                    textContentType: UITextContentType.name
                )
                
                ProfileFieldView(
                    label: "Email",
                    text: $tempEmail,
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    textContentType: UITextContentType.emailAddress
                )
                
                ProfileFieldView(
                    label: "Phone",
                    text: $tempPhone,
                    keyboardType: .phonePad,
                    autocapitalization: .never,
                    textContentType: UITextContentType.telephoneNumber
                )
            },
            header: {
                Text("Personal Information")
            }
        )
        .onChange(of: tempName) {
            updateProfile()
        }
        
        .onChange(of: tempEmail) {
            updateProfile()
        }
        
        .onChange(of: tempPhone) {
            updateProfile()
        }
        
    }
    
    private func updateProfile() {
        var updatedProfile = profile
        updatedProfile.name = tempName
        updatedProfile.email = tempEmail
        updatedProfile.phone = tempPhone
        onProfileChange(updatedProfile)
    }
}

