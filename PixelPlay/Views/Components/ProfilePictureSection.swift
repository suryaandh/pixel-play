import SwiftUI

struct ProfilePictureSection: View {
    let imageURL: String
    let onImageURLChange: (String) -> Void
    @State private var tempImageURL: String
    
    init(imageURL: String, onImageURLChange: @escaping (String) -> Void) {
        self.imageURL = imageURL
        self.onImageURLChange = onImageURLChange
        self._tempImageURL = State(initialValue: imageURL)
    }
    
    var body: some View {
        Section(header: Text("Profile Picture")) {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: tempImageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    case .failure(_):
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Image URL")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Enter image URL", text: $tempImageURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: tempImageURL) {
                            onImageURLChange(tempImageURL)
                        }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

