//
//  History.swift
//  Entity
//
//  Created by 정다은 on 1/21/25.
//

import Foundation
import RealmSwift

public struct History {
    public let id: String
    public let bookID: String
    public let memos: [String]
    public let passageIDs: [String]
    public let createdDate: Date
}

public class RealmHistory: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var bookID: String = ""
    @Persisted public var memos = List<String>()
    @Persisted public var passageIDs = List<String>()
    @Persisted var createdDate: Date = Date()
    
    public convenience init(id: String, bookID: String, memos: List<String>, passageIDs: List<String>, createdDate: Date) {
        self.init(value: [id, bookID, memos, passageIDs, createdDate])
    }
    
    public func convertToModel() -> History {
        return History(id: id, bookID: bookID, memos: Array(memos), passageIDs: Array(passageIDs), createdDate: createdDate)
    }
}
