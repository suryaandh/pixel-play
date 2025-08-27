import SwiftUI

struct FavoriteRowView: View {
    var fav: FavoriteGame
    @ObservedObject var vm: FavoriteViewModel
    @State private var isRemoving = false
    @Binding var selectGameId: Int?
    
    @State private var isActive = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: fav.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2).overlay(ProgressView())
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Color.red.overlay(
                        Image(systemName: "xmark.octagon")
                            .foregroundColor(.white)
                    )
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 100, height: 100)
            .cornerRadius(12)
            .clipped()
            .background(
                NavigationLink (destination: GameDetailView(gameId: Int(fav.id)) ){
                }.opacity(0)
            )
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text(fav.title ?? "Unknown Title")
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Label(fav.released?.formattedDate() ?? "-", systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label(String(format: "%.1f", fav.rating), systemImage: "star.fill")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }
            
            Spacer()
            
            Button {
                Task {
                    isRemoving = true
                    await vm.toggleFavorite(favoriteGame: fav)
                    isRemoving = false
                }
            } label: {
                if isRemoving {
                    ProgressView().scaleEffect(0.8)
                } else {
                    Image(systemName: "heart.fill").foregroundColor(.red)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isRemoving)
        }
        .padding(.vertical, 6)
    }
}
