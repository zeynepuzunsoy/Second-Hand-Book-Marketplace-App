//
//  User.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 28.05.2023.
//

import Foundation
import Alamofire
import UIKit

struct User: Codable {
    let userID: Int?
    let name, email: String?
    let emailVerifiedAt: JSONNull?
    let isActive: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, email
        case emailVerifiedAt = "email_verified_at"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct SignUpResponse: Decodable {
    let user: User
    let token: String
}


struct SignInResponse: Decodable {
    let user: User
    let token: String
}

struct LogoutResponse: Decodable {
    let message: String
}

