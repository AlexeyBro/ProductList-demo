//
//  ProductModel.swift
//  Redsoft
//
//  Created by Alex Bro on 11.11.2020.
//

import Foundation

struct ProductsModel: Codable {
    let data: [Products]
}

struct Products: Codable {
    let id: Int
    let title, shortDescription: String
    let imageURL: String
    let amount: Int
    let price: Double
    let producer: String
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case id, title
        case shortDescription = "short_description"
        case imageURL = "image_url"
        case amount, price, producer, categories
    }
}

struct Category: Codable {
    let id: Int
    let title: String
    let parentID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case parentID = "parent_id"
    }
}
