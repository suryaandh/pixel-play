import Foundation

// MARK: - GameDetail (sesuai /games/{id})
struct GameDetail: Codable {
    let id: Int
    let slug: String?
    let name: String
    let nameOriginal: String?
    let description: String?
    let descriptionRaw: String?
    let metacritic: Int?
    let metacriticPlatforms: [GDMetacriticPlatform]?
    let released: String?
    let tba: Bool?
    let updated: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let reactions: [String: Int]?
    let added: Int?
    let addedByStatus: AddedByStatus?
    let playtime: Int?
    let screenshotsCount: Int?
    let moviesCount: Int?
    let creatorsCount: Int?
    let achievementsCount: Int?
    let parentAchievementsCount: Int?
    let redditURL: String?
    let redditName: String?
    let redditDescription: String?
    let redditLogo: String?
    let redditCount: Int?
    let twitchCount: Int?
    let youtubeCount: Int?
    let reviewsTextCount: Int?
    let ratingsCount: Int?
    let suggestionsCount: Int?
    let alternativeNames: [String]?
    let metacriticURL: String?
    let parentsCount: Int?
    let additionsCount: Int?
    let gameSeriesCount: Int?
    let userGame: String?
    let reviewsCount: Int?
    let saturatedColor: String?
    let dominantColor: String?
    let parentPlatforms: [ParentPlatformList]?
    let platforms: [GDPlatformEntry]?
    let stores: [GDStoreLink]?
    let developers: [GDCompany]?
    let publishers: [GDCompany]?
    let genres: [Genre]?
    let tags: [GDTag]?
    let esrbRating: EsrbRatingList?
    let clip: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description
        case descriptionRaw = "description_raw"
        case metacritic
        case metacriticPlatforms = "metacritic_platforms"
        case released, tba, updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case ratingTop = "rating_top"
        case ratings, reactions, added
        case addedByStatus = "added_by_status"
        case playtime
        case screenshotsCount = "screenshots_count"
        case moviesCount = "movies_count"
        case creatorsCount = "creators_count"
        case achievementsCount = "achievements_count"
        case parentAchievementsCount = "parent_achievements_count"
        case redditURL = "reddit_url"
        case redditName = "reddit_name"
        case redditDescription = "reddit_description"
        case redditLogo = "reddit_logo"
        case redditCount = "reddit_count"
        case twitchCount = "twitch_count"
        case youtubeCount = "youtube_count"
        case reviewsTextCount = "reviews_text_count"
        case ratingsCount = "ratings_count"
        case suggestionsCount = "suggestions_count"
        case alternativeNames = "alternative_names"
        case metacriticURL = "metacritic_url"
        case parentsCount = "parents_count"
        case additionsCount = "additions_count"
        case gameSeriesCount = "game_series_count"
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case parentPlatforms = "parent_platforms"
        case platforms, stores, developers, publishers, genres, tags
        case esrbRating = "esrb_rating"
        case clip
    }
}

// MARK: - Metacritic (detail)
struct GDMetacriticPlatform: Codable {
    let metascore: Int?
    let url: String?
    let platform: GDMetaPlatformRef?
}

struct GDMetaPlatformRef: Codable {
    let platform: Int?
    let name: String?
    let slug: String?
}

// MARK: - Platform entries (detail)
struct GDPlatformEntry: Codable {
    let platform: GDPlatformInfo
    let releasedAt: String?
    let requirements: GDRequirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

struct GDPlatformInfo: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let image: String?
    let yearEnd: Int?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct GDRequirements: Codable {
    let minimum: String?
    let recommended: String?
}

// MARK: - Stores (detail)
struct GDStoreLink: Codable {
    let id: Int?
    let url: String?
    let store: StoreDetail
}

// MARK: - Dev/Publisher (detail)
struct GDCompany: Codable {
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

// MARK: - Tags (detail)
struct GDTag: Codable {
    let id: Int
    let name: String
    let slug: String
    let language: String?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
