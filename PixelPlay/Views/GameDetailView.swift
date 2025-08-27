import SwiftUI

struct GameDetailView: View {
    let gameId: Int
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var favorite = FavoriteViewModel()
    
    @State private var isFavorite = false
    @State private var isTogglingFavorite = false
    @State private var isInitializing = true
    
    var body: some View {
        ScrollView {
            if let game = viewModel.selectedGame {
                VStack(alignment: .leading, spacing: 16) {
                    
                    AsyncImage(url: URL(string: game.backgroundImage ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 300)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 240)
                            .overlay(ProgressView())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Text(game.name)
                                .font(.system(size: 28, weight: .bold))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            Button(action: {
                                Task {
                                    isTogglingFavorite = true
                                    await favorite.toggleFavorite(game: game)
                                    isFavorite = await favorite.isFavorite(game)
                                    isTogglingFavorite = false
                                }
                            }) {
                                if isTogglingFavorite {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(isFavorite ? .red : .primary)
                                        .imageScale(.large)
                                }
                            }
                            .disabled(isTogglingFavorite)
                        }
                        
                        
                        HStack(spacing: 16) {
                            if let released = game.released {
                                Label(released.formattedDate(), systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let rating = game.rating, let top = game.ratingTop {
                                let ratingText = String(format: "%.1f", rating) + "/" + String(top)
                                Label(ratingText, systemImage: "star.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                            }
                            if let playtime = game.playtime, playtime > 0 {
                                let playtimeString = String(format: "\(playtime)h avg")
                                Label(playtimeString, systemImage: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    if !viewModel.screenshots.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("screenshot_title")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.screenshots, id: \.id) { shot in
                                        AsyncImage(url: URL(string: shot.image)) { img in
                                            img.resizable()
                                                .scaledToFill()
                                                .frame(width: 280, height: 160)
                                                .clipped()
                                                .cornerRadius(10)
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 280, height: 160)
                                                .overlay(ProgressView())
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("description")
                            .font(.headline)
                        Text(game.descriptionRaw ?? "-")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if let developers = game.developers, !developers.isEmpty {
                            Text(verbatim: "Developer: \(developers.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let publishers = game.publishers, !publishers.isEmpty {
                            Text(verbatim: "Publisher: \(publishers.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let platforms = game.platforms {
                            Text(verbatim: "Platforms: \(platforms.map{$0.platform.name ?? ""}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let genres = game.genres, !genres.isEmpty {
                            Text(verbatim: "Genres: \(genres.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            } else if viewModel.isLoading {
                ProgressView( "loading")
                    .frame(maxWidth: .infinity, minHeight: 300)
            } else if let error = viewModel.errorMessage {
                Text(verbatim: "Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("game_detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGameDetail(id: gameId)
            await viewModel.loadScreenshots(for: gameId)
            
            if let game = viewModel.selectedGame {
                isFavorite = await favorite.isFavorite(game)
                isInitializing = false
            }
        }
    }
}
