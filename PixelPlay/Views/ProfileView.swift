import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://media.licdn.com/dms/image/v2/D5603AQFXlh5bA48sVQ/profile-displayphoto-scale_400_400/B56ZfUDBcPGQAk-/0/1751609253482?e=1758758400&v=beta&t=U1bxAcMOSNNZotRVNiRsLUJzmTblxwWRAfNtvOAjz5M")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    case .failure(_):
                        Image("app-splash")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                
                Text("Gde Swiyasa")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, 32)
            
            
            List {
                Section(header: Text("Account")) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.secondary)
                        Text("Email")
                        Spacer()
                        Text("gdeswiyasa123@gmail.com")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.secondary)
                        Text("Phone")
                        Spacer()
                        Text("+62 812 3456 7890")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Edit Profile")) {
                        Label{
                            Text("Edit Profile")
                        } icon: {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink(destination: Text("Change Password")) {
                        Label {
                            Text("Change Password")
                        } icon: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
            }
        }
    }
}

