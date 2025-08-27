import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var editViewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self._editViewModel = StateObject(wrappedValue: EditProfileViewModel(profileViewModel: viewModel))
    }
    
    var body: some View {
        Form {
            ProfilePictureSection(
                imageURL: editViewModel.tempProfile.imageURL,
                onImageURLChange: { newURL in
                    var updated = editViewModel.tempProfile
                    updated.imageURL = newURL
                    editViewModel.updateTempProfile(updated)
                }
            )
            
            PersonalInformationSection(
                profile: editViewModel.tempProfile,
                onProfileChange: { newProfile in
                    editViewModel.updateTempProfile(newProfile)
                }
            )
            
            ResetSection(
                isUpdating: editViewModel.isUpdating,
                onReset: {
                    editViewModel.showingResetAlert = true
                }
            )
            
            ValidationErrorSection(error: editViewModel.validationError)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .disabled(editViewModel.isUpdating)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if editViewModel.isUpdating {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button("Save") {
                        Task {
                            await editViewModel.saveProfile()
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Profile Saved", isPresented: $editViewModel.showingSaveAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your profile has been updated successfully!")
        }
        .alert("Reset Profile", isPresented: $editViewModel.showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                Task {
                    await editViewModel.resetProfile()
                }
            }
        } message: {
            Text("Are you sure you want to reset your profile to default values?")
        }
        .alert("Error", isPresented: $editViewModel.showingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(editViewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}
