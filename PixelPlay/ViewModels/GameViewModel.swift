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
    
    @Published var loadGamesError: String?
    @Published var loadDetailError: String?
    @Published var loadScreenshotsError: String?
    
    private let service = GameService()
    private var currentPage = 1
    private var canLoadMore = true
    
    func loadGames() async {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        loadGamesError = nil
        
        do {
            let response = try await service.fetchGames(page: currentPage, pageSize: 20)
            games.append(contentsOf: response.results)
            
            if response.next != nil {
                currentPage += 1
            } else {
                canLoadMore = false
            }
        } catch {
            loadGamesError = handleError(error)
        }
        
        isLoading = false
    }
    
    func loadGameDetail(id: Int) async {
        isLoading = true
        loadDetailError = nil
        errorMessage = nil
        
        do {
            let detail = try await service.fetchGameDetail(id: id)
            self.selectedGame = detail
        } catch {
            let errorMsg = handleError(error)
            loadDetailError = errorMsg
            errorMessage = errorMsg
            print("Load game detail error: \(error)")
        }
        
        isLoading = false
    }
    
    func loadScreenshots(for gameId: Int) async {
        isLoading = true
        loadScreenshotsError = nil
        errorMessage = nil
        
        do {
            let shots = try await service.fetchScreenshots(for: gameId)
            self.screenshots = shots
        } catch {
            let errorMsg = handleError(error)
            loadScreenshotsError = errorMsg
            errorMessage = errorMsg
        }
        
        isLoading = false
    }
    
    func searchGames(query: String) async {
        guard !query.isEmpty else { return }
        
        isSearching = true
        searchError = nil
        
        defer { isSearching = false }
        
        do {
            let response = try await service.searchGames(query: query)
            self.searchResults = response.results
        } catch {
            searchError = handleError(error)
            print("Search games error: \(error)")
        }
    }
    
    func retryLoadGames() async {
        await loadGames()
    }
    
    func clearErrors() {
        errorMessage = nil
        loadGamesError = nil
        loadDetailError = nil
        loadScreenshotsError = nil
        searchError = nil
    }
    
    func refreshGames() async {
        currentPage = 1
        canLoadMore = true
        games.removeAll()
        await loadGames()
    }
    
    private func handleError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "Tidak ada koneksi internet. Periksa koneksi Anda."
            case .timedOut:
                return "Koneksi timeout. Coba lagi nanti."
            case .cannotFindHost, .cannotConnectToHost:
                return "Tidak dapat terhubung ke server."
            default:
                return "Terjadi masalah jaringan. Coba lagi nanti."
            }
        }
        
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidResponse:
                return "Response server tidak valid."
            case .decodingError:
                return "Terjadi kesalahan saat memproses data."
            case .serverError(let message):
                return message.isEmpty ? "Terjadi kesalahan server." : message
            }
        }
        
        return "Terjadi kesalahan. Silakan coba lagi."
    }
}

enum APIError: Error, LocalizedError {
    case invalidResponse
    case decodingError
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        }
    }
}
