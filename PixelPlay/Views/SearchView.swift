import SwiftUI
import Combine

struct SearchView: View {
    @State private var query: String = ""
    @StateObject private var viewModel = GameViewModel()
    
    @State private var debounceCancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search Game...", text: $query)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: query) { oldValue, newValue in
                            debounceCancellable?.cancel()
                            debounceCancellable = Just(newValue)
                                .delay(for: .milliseconds(500), scheduler: RunLoop.main)
                                .sink { text in
                                    Task { await viewModel.searchGames(query: text) }
                                }
                        }
                    
                    if !query.isEmpty {
                        Button {
                            query = ""
                            viewModel.searchResults = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)
                
                
                if viewModel.isSearching {
                    Spacer()
                    ProgressView("searching game...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .font(.headline)
                    Spacer()
                }
                
                
                else if let error = viewModel.searchError {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Something went wrong")
                            .font(.title3)
                            .bold()
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                }
                
                
                else if !query.isEmpty && viewModel.searchResults.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No games found")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                
                else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.searchResults, id: \.id) { game in
                                NavigationLink(destination: GameDetailView(gameId: game.id)) {
                                    GameSearchCard(game: game)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Search Games")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
