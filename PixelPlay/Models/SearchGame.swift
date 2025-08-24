import Foundation

// MARK: - GameSearchResponse
struct GameSearchResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameSearch]
}

// MARK: - GameSearch (result item)
struct GameSearch: Codable, Identifiable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let metacritic: Int?
    let playtime: Int
    let platforms: [PlatformElementSearch]?
    let stores: [StoreElementSearch]?
    let genres: [GenreSearch]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, rating, metacritic, playtime, platforms, stores, genres
        case backgroundImage = "background_image"
    }
}

// MARK: - PlatformElement
struct PlatformElementSearch: Codable {
    let platform: PlatformSearch
}

// MARK: - Platform
struct PlatformSearch: Codable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - StoreElement
struct StoreElementSearch: Codable {
    let store: StoreSearch?
}

// MARK: - Store
struct StoreSearch: Codable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - Genre
struct GenreSearch: Codable {
    let id: Int
    let name: String
    let slug: String
}

