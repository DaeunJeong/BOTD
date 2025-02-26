//
//  Passage.swift
//  Entity
//
//  Created by 정다은 on 1/21/25.
//

import Foundation
import RealmSwift

public struct Passage {
    public let id: String
    public let text: String
    public let historyID: String
}

public class RealmPassage: Object {
    @Persisted(primaryKey: true) public var id: String = ""
    @Persisted var text: String = ""
    @Persisted var historyID: String = ""
    
    public convenience init(id: String, text: String, historyID: String) {
        self.init(value: [id, text, historyID])
    }
    
    public func convertToModel() -> Passage {
        return Passage(id: id, text: text, historyID: historyID)
    }
}
