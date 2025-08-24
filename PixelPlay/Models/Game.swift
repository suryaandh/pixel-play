import Foundation

// MARK: - GameResponse
struct GameResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}

// MARK: - Game
struct Game: Codable, Identifiable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let ratings: [Rating]
    let ratingsCount: Int
    let reviewsTextCount: Int
    let added: Int
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let playtime: Int
    let suggestionsCount: Int
    let updated: String
    let userGame: String?
    let reviewsCount: Int
    let saturatedColor: String
    let dominantColor: String
    let platforms: [PlatformElementList]?
    let parentPlatforms: [ParentPlatformList]?
    let genres: [Genre]
    let stores: [Store]?
    let clip: Clip?
    let tags: [Genre]
    let esrbRating: EsrbRatingList?
    let shortScreenshots: [ShortScreenshot]

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case platforms
        case parentPlatforms = "parent_platforms"
        case genres, stores, clip, tags
        case esrbRating = "esrb_rating"
        case shortScreenshots = "short_screenshots"
    }
}

// MARK: - AddedByStatus
struct AddedByStatus: Codable {
    let yet: Int?
    let owned: Int?
    let beaten: Int?
    let toplay: Int?
    let dropped: Int?
    let playing: Int?
}

// MARK: - EsrbRating
struct EsrbRatingList: Codable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - Genre (dipakai juga untuk tags)
struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - ParentPlatform
struct ParentPlatformList: Codable {
    let platform: PlatformInfo
}

struct PlatformInfo: Codable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - PlatformElement
struct PlatformElementList: Codable {
    let platform: PlatformDetail
    let releasedAt: String?
    let requirementsEn: RequirementsEn?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirementsEn = "requirements_en"
    }
}

struct PlatformDetail: Codable {
    let id: Int
    let name: String
    let slug: String
    let yearStart: Int?
    let yearEnd: Int?
    let gamesCount: Int
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case yearStart = "year_start"
        case yearEnd = "year_end"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - RequirementsEn
struct RequirementsEn: Codable {
    let minimum: String?
    let recommended: String?
}

// MARK: - Rating
struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable {
    let id: Int
    let image: String
}

// MARK: - Store
struct Store: Codable {
    let id: Int
    let store: StoreDetail
}

struct Clip: Codable {
    let clip: String?
}

struct StoreDetail: Codable {
    let id: Int
    let name: String
    let slug: String
    let domain: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, domain
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
