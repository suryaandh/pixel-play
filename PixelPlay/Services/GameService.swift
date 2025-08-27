import Foundation

final class GameService {
    private let baseUrl: String
    private let apiKey: String
    
    init() {
        guard
            let base = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            let key  = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
            !base.isEmpty, !key.isEmpty
        else {
            preconditionFailure("API_BASE_URL / API_KEY belum terkonfigurasi di Info.plist / .xcconfig")
        }
        print("🔧 Loaded API_BASE_URL:", base)
        print("🔧 Loaded API_KEY:", key)
        self.baseUrl = base
        self.apiKey  = key
    }
    
    private func makeURL(path: String, query: [String: String] = [:]) throws -> URL {
        guard var components = URLComponents(string: baseUrl + path) else {
            throw URLError(.badURL)
        }
        
        var items: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        for (k, v) in query {
            items.append(URLQueryItem(name: k, value: v))
        }
        
        components.queryItems = items
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
    
    func fetchGames(page: Int = 1, pageSize: Int = 20) async throws -> GameResponse {
        let url = try makeURL(path: "/games", query: [
            "page": "\(page)",
            "page_size": "\(pageSize)"
        ])
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(GameResponse.self, from: data)
    }
    
    func fetchGameDetail(id: Int) async throws -> GameDetail {
        let url = try makeURL(path: "/games/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(GameDetail.self, from: data)
    }
    
    func fetchScreenshots(for gameId: Int) async throws -> [Screenshot] {
        let url = try makeURL(path: "/games/\(gameId)/screenshots")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ScreenshotResponse.self, from: data).results
    }
    
    func searchGames(query: String, page: Int = 1, pageSize: Int = 20) async throws -> GameSearchResponse {
        let url = try makeURL(path: "/games", query: [
            "search": query,
            "page": "\(page)",
            "page_size": "\(pageSize)"
        ])
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(GameSearchResponse.self, from: data)
    }
}
