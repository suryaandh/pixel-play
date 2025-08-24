import Foundation

struct ScreenshotResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Screenshot]
}

struct Screenshot: Codable, Identifiable {
    let id: Int
    let image: String
    let width: Int?
    let height: Int?
    let isDeleted: Bool?

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}

