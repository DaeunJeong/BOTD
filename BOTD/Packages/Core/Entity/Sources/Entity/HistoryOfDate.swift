//
//  HistoryOfDate.swift
//  Entity
//
//  Created by 정다은 on 1/21/25.
//

import Foundation
import RealmSwift

public struct HistoryOfDate {
    public let id: String // yyyyMMdd
    public let historyIDs: [String]
}

public class RealmHistoryOfDate: Object {
    @Persisted(primaryKey: true) var id: String = "" // yyyyMMdd
    @Persisted public var historyIDs = List<String>()
    
    public convenience init(id: String, historyIDs: [String]) {
        let historyIDList = List<String>()
        historyIDList.append(objectsIn: historyIDs)
        self.init(value: [id, historyIDList])
    }
    
    public func convertToModel() -> HistoryOfDate {
        return HistoryOfDate(id: id, historyIDs: historyIDs.map(\.self))
    }
}
