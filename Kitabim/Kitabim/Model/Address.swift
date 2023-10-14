//
//  Address.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import Foundation


struct UaddressResponse: Codable {
    let message: String?
    let address: Address
}



struct AddressResponse: Codable {
    let address: [Address]
}

struct Address: Codable {
    let addressId: Int?
    let userId: Int?
    let city: String?
    let district: String?
    let zipcode: String?
    let address: String?
    let isDefault: Int?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let name: String?
    let lastname: String?
    let phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case addressId = "address_id"
        case userId = "user_id"
        case city
        case district
        case zipcode
        case address
        case isDefault = "is_default"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case lastname
        case phoneNumber = "phone_number"
    }
}




//
//struct Address: Codable {
//    let addressId: Int?
//    let userId: Int?
//    let city: String?
//    let district: String?
//    let zipcode: String?
//    let address: String?
//    let isDefault: Int?
//    let deletedAt: String?
//    let createdAt: String?
//    let updatedAt: String?
//    let name: String?
//    let lastname: String?
//    let phoneNumber: String?
//
//    enum CodingKeys: String, CodingKey {
//        case addressId = "address_id"
//        case userId = "user_id"
//        case city
//        case district
//        case zipcode
//        case address
//        case isDefault = "is_default"
//        case deletedAt = "deleted_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case name
//        case lastname
//        case phoneNumber = "phone_number"
//    }
//}
