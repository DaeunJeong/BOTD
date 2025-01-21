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
}

public class RealmPassage: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var text: String = ""
    
    public func convertToModel() -> Passage {
        return Passage(id: id, text: text)
    }
}
