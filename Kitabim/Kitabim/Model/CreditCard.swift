//
//  CreditCard.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 13.06.2023.
//

import Foundation

struct CreditCardResponse: Codable {
    let creditCard: [CreditCard]
}


struct DeleteResponse: Codable {
    let message: String
}


struct CreditCard: Codable {
    let name: String?
    let cardNo: String?
    let expireMonth: String?
    let expireYear: String?
    let cvc: String?
    let userId: Int?
    let updatedAt: String?
    let createdAt: String?
    let creditCardId: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case cardNo = "card_no"
        case expireMonth = "expire_month"
        case expireYear = "expire_year"
        case cvc
        case userId = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case creditCardId = "credit_card_id"
    }
}
