import SwiftUI

struct GenericGameCard<T>: View {
    let item: T
    let getName: (T) -> String
    let getBackgroundImage: (T) -> String?
    let getReleased: (T) -> String?
    let getRating: (T) -> Double?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            AsyncImage(url: URL(string: getBackgroundImage(item) ?? "")) { image in
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
                Text(getName(item))
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Label(getReleased(item)?.formattedDate() ?? "-", systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                if let rating = getRating(item) {
                    Label(String(format: "%.1f", rating), systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
            }
            .padding()
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 6)
    }
}

extension GenericGameCard where T == Game {
    init(game: Game) {
        self.init(
            item: game,
            getName: { $0.name },
            getBackgroundImage: { $0.backgroundImage },
            getReleased: { $0.released },
            getRating: { $0.rating }
        )
    }
}

extension GenericGameCard where T == GameSearch {
    init(gameSearch: GameSearch) {
        self.init(
            item: gameSearch,
            getName: { $0.name },
            getBackgroundImage: { $0.backgroundImage },
            getReleased: { $0.released },
            getRating: { _ in nil }
        )
    }
}
