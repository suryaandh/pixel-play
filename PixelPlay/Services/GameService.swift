import Foundation

class GameService {
    private let baseUrl = "https://api.rawg.io/api"
    private let apiKey = "685766cbf4a441ba9914bd7358a38a5b"
    
    func fetchGames(page: Int = 1, pageSize: Int = 20) async throws -> GameResponse {
        guard let url = URL(string: "\(baseUrl)/games?key=\(apiKey)&page=\(page)&page_size=\(pageSize)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(GameResponse.self, from: data)
        return decoded
    }
    
    func fetchGameDetail(id: Int) async throws -> GameDetail {
        guard let url = URL(string: "\(baseUrl)/games/\(id)?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(GameDetail.self, from: data)
        print("✅ Game detail fetched:", decoded)
        return decoded
    }
    
    func fetchScreenshots(for gameId: Int) async throws -> [Screenshot] {
        guard let url = URL(string: "\(baseUrl)/games/\(gameId)/screenshots?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ScreenshotResponse.self, from: data)
        return decoded.results
    }
    
    func searchGames(query: String, page: Int = 1, pageSize: Int = 20) async throws -> GameSearchResponse {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "\(baseUrl)/games?key=\(apiKey)&search=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else {
            throw URLError(.badURL)
        }
        
        print("🔍 Search URL:", url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status code:", httpResponse.statusCode)
        }
        
        // Debug raw JSON kalau perlu
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 Raw JSON Response:", jsonString.prefix(500), "...") // jangan print semua kalau besar
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(GameSearchResponse.self, from: data)
        print("✅ Decoded results:", decoded.results.count, "games")
        
        return decoded
    }
}
