import SwiftUI

struct ProfileHeaderView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: profile.imageURL)) { phase in
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
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.gray)
                        .shadow(radius: 5)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(profile.name)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

