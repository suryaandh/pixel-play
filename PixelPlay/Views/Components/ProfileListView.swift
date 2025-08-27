import SwiftUI

struct ProfileListView: View {
    let profile: UserProfile
    let viewModel: ProfileViewModel
    
    var body: some View {
        List {
            Section(header: Text("Account")) {
                ProfileRowView(
                    icon: "envelope.fill",
                    title: "Email",
                    value: profile.email
                )
                
                ProfileRowView(
                    icon: "phone.fill",
                    title: "Phone",
                    value: profile.phone
                )
            }
            
            Section(header: Text("Settings")) {
                NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                    Label {
                        Text("edit_profile")
                    } icon: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink(destination:  Text("change_password")) {
                    Label {
                        Text("change_password")
                    } icon: {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


