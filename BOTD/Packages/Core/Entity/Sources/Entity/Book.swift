//
//  Book.swift
//  Entity
//
//  Created by 정다은 on 1/21/25.
//

import Foundation
import RealmSwift

public struct Book {
    public let id: String
    public let imageURL: URL?
    public let createdDate: Date
}

public class RealmBook: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var imageURLString: String?
    @Persisted var createdDate: Date = Date()
    
    public convenience init(id: String, imageURL: URL?, createdDate: Date) {
        self.init(value: [id, imageURL?.absoluteString ?? "", createdDate])
    }
    
    public func convertToModel() -> Book {
        return Book(id: id, imageURL: imageURLString.flatMap(URL.init(string:)), createdDate: createdDate)
    }
}
