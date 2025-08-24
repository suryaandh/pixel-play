import SwiftUI

struct GameCard: View {
    let game: Game
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            AsyncImage(url: URL(string: game.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                LinearGradient(
                    colors: [.gray.opacity(0.3), .gray.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: 200)
            .clipped()
            
            LinearGradient(
                colors: [Color.black.opacity(0.7), Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(game.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Label(game.released?.formattedDate() ?? "-", systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 6)
    }
}
