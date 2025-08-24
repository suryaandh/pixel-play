import Foundation

@MainActor
class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var selectedGame: GameDetail?
    @Published var errorMessage: String?
    @Published var screenshots: [Screenshot] = []
    @Published var searchResults: [GameSearch] = []
    @Published var isSearching = false
    @Published var searchError: String?
    
    
    private let service = GameService()
    private var currentPage = 1
    private var canLoadMore = true
    
    func loadGames() async {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        do {
            let response = try await service.fetchGames(page: currentPage, pageSize: 20)
            games.append(contentsOf: response.results)
            if response.next != nil {
                currentPage += 1
            } else {
                canLoadMore = false
            }
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func loadGameDetail(id: Int) async {
        isLoading = true
        do {
            let detail = try await service.fetchGameDetail(id: id)
            self.selectedGame = detail
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func loadScreenshots(for gameId: Int) async {
        isLoading = true
        do {
            let shots = try await service.fetchScreenshots(for: gameId)
            self.screenshots = shots
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func searchGames(query: String) async {
        guard !query.isEmpty else {return}
        
        isSearching = true
        defer{isSearching = false}
        
        do{
            let response = try await service.searchGames(query: query)
            self.searchResults = response.results
        } catch {
            searchError = error.localizedDescription
            print("Decoding error:", error)

        }
    }
}
