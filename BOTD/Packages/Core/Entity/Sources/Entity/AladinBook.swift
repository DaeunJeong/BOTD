//
//  AladinBook.swift
//  Entity
//
//  Created by 정다은 on 2/7/25.
//

import Foundation

public struct AladinBook: Decodable {
    public let title: String
    public let author: String
    public let description: String
    public let coverImageURL: URL?
    public let publisher: String
    
    enum CodingKeys: String, CodingKey {
        case title, author, description, publisher
        case coverImageURL = "cover"
    }
}
