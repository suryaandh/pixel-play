import SwiftUI

struct GameDetailView: View {
    let gameId: Int
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ScrollView {
            if let game = viewModel.selectedGame {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Header Image
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
                    
                    // Title & Basic Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(game.name)
                            .font(.system(size: 28, weight: .bold))
                        
                        HStack(spacing: 16) {
                            if let released = game.released {
                                Label(released.formattedDate(), systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let rating = game.rating, let top = game.ratingTop {
                                Label("\(String(format: "%.1f", rating))/\(top)", systemImage: "star.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                            }
                            if let playtime = game.playtime, playtime > 0 {
                                Label("\(playtime)h avg", systemImage: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // Screenshots Carousel
                    if !viewModel.screenshots.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Screenshots")
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

                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                        Text(game.descriptionRaw ?? "-")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    
                    // Extra Info
                    VStack(alignment: .leading, spacing: 12) {
                        if let developers = game.developers, !developers.isEmpty {
                            Text("Developer: \(developers.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let publishers = game.publishers, !publishers.isEmpty {
                            Text("Publisher: \(publishers.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let platforms = game.platforms {
                            Text("Platforms: \(platforms.map{$0.platform.name ?? ""}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let genres = game.genres, !genres.isEmpty {
                            Text("Genres: \(genres.map{$0.name}.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            } else if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, minHeight: 300)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Game Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGameDetail(id: gameId)
            await viewModel.loadScreenshots(for: gameId)
        }
    }
}
