//
//  Category.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 20.03.2023.
//

import Foundation
import UIKit
import Alamofire

struct CategoryResponse: Decodable {
//    let products: [Product]
    let categories: [Category]
    let users: [User]
 }

struct Category: Codable {
    let category_id: Int
    let name: String
    let slug: String
    let is_active: Int
}


