import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favorites: [FavoriteGame] = []
    @Published var isLoading = false
    
    private let service = FavoriteService()
    
    init() {
        Task {
            await loadFavorites()
        }
    }
    
    func loadFavorites() async {
        isLoading = true
        defer { isLoading = false }
        
        favorites = await service.getFavorites()
    }
    
    func toggleFavorite(game: GameDetail) async {
        if await service.isFavorite(id: game.id) {
            await service.removeFromFavorite(id: game.id)
        } else {
            await service.addToFavorite(game: game)
        }
        
        await loadFavorites()
    }

    func toggleFavorite(favoriteGame: FavoriteGame) async {
        await service.removeFromFavorite(id: Int(favoriteGame.id))
        await loadFavorites()
    }
    
    func isFavorite(_ game: GameDetail) async -> Bool {
        return await service.isFavorite(id: game.id)
    }
    
    func isFavoriteSync(_ game: GameDetail) -> Bool {
        return favorites.contains { $0.id == game.id }
    }
}

