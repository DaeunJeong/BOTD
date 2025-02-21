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
    public let title: String
    public let imageURL: URL?
    public let createdDate: Date
    public let historyIDs: [String]
}

public class RealmBook: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var title: String = ""
    @Persisted var imageURLString: String?
    @Persisted var createdDate: Date = Date()
    @Persisted public var historyIDs = List<String>()
    
    public convenience init(id: String, title: String, imageURL: URL?, createdDate: Date, historyIDs: [String]) {
        let historyIDList = List<String>()
        historyIDList.append(objectsIn: historyIDs)
        self.init(value: [id, title, imageURL?.absoluteString ?? "", createdDate, historyIDList])
    }
    
    public func convertToModel() -> Book {
        return Book(id: id, title: title, imageURL: imageURLString.flatMap(URL.init(string:)), createdDate: createdDate,
                    historyIDs: historyIDs.map(\.self))
    }
}
