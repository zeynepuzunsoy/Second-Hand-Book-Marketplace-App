//
//  Payment.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 10.06.2023.
//

import Foundation

struct PaymentResponse: Codable {
    let message: String?
    let totalPrice: Double?

    enum CodingKeys: String, CodingKey {
        case message
        case totalPrice = "total_price"
    }
}
