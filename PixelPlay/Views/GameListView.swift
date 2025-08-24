import SwiftUI

struct GameListView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            HStack{
                Text("🎮 Pixel Play")
                    .font(.system(size: 20))
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    SearchView()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(width: 16)
                
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)]) {
                    ForEach(viewModel.games, id: \.id) { game in
                        NavigationLink(destination: GameDetailView(gameId: game.id)) {
                            GameCard(game: game)
                        }
                        .onAppear {
                            if game.id == viewModel.games.last?.id {
                                Task { await viewModel.loadGames() }
                            }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading more...")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.large)
        
        .task {
            await viewModel.loadGames()
        }
    }
}

