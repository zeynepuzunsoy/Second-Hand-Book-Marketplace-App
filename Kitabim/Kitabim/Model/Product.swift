import Foundation


// MARK: - ProductResponse
struct ProductResponse: Codable {
    let message: String?
    let product: Product?
}

struct Products: Codable {
    let product: [Product]
}



// MARK: - Product
struct Product: Codable {
    let categoryID : Int?
    let name, price, description: String?
    let userID: Int?
    let updatedAt, createdAt: String?
    let productID: Int?
    let user: User?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case name, price, description
        case userID = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case productID = "product_id"
        case user, images
    }
}

// MARK: - Image
struct Image: Codable {
    let imageID, productID: Int?
    let imageURL: String?
    let altText: JSONNull?
    let seq, isActive, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
        case productID = "product_id"
        case imageURL = "image_url"
        case altText = "alt_text"
        case seq
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
//struct User: Codable {
//    let userID: Int?
//    let name, email: String?
//    let emailVerifiedAt: JSONNull?
//    let isActive: Int?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case name, email
//        case emailVerifiedAt = "email_verified_at"
//        case isActive = "is_active"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


