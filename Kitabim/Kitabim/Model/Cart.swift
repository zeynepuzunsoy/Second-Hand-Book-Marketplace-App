//
//  Cart.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 9.06.2023.
//

import Foundation

struct CartResponse: Codable {
    let cartID: Int?
    let userID: Int?
    let code: String?
    let isActive: Int?
    let createdAt: String?
    let details: [CartDetailResponse]?

    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case userID = "user_id"
        case code
        case isActive = "is_active"
        case createdAt = "created_at"
        case details
    }
}

struct CartDetailResponse: Codable {
    let cartDetailID: Int?
    let cartID: Int?
    let productID: Int?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case cartDetailID = "cart_detail_id"
        case cartID = "cart_id"
        case productID = "product_id"
        case quantity
    }
}
