//
//  WriteHistoryRepository.swift
//  WriteHistory
//
//  Created by 정다은 on 2/12/25.
//

import Foundation
import RealmSwift
import Entity

public protocol WriteHistoryRepositoryProtocol {
    func writeHistory(date: Date, book: SearchBookResultDisplayable, memoList: [String], passageList: [String])
}

public struct WriteHistoryRepository: WriteHistoryRepositoryProtocol {
    let realm: Realm
    
    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    public func writeHistory(date: Date, book: SearchBookResultDisplayable, memoList: [String], passageList: [String]) {
        let dateFormatter = DateFormatter(dateFormat: "yyyyMMdd")
        let historyOfDateID = dateFormatter.string(from: date)
        
        let historyID = UUID().uuidString
        var historyIDs = [historyID]
        if let historyOfDate = realm.object(ofType: RealmHistoryOfDate.self, forPrimaryKey: historyOfDateID)?.convertToModel() {
            historyIDs.insert(contentsOf: historyOfDate.historyIDs, at: 0)
        }
        
        let historyOfDate = RealmHistoryOfDate(id: historyOfDateID, historyIDs: historyIDs)
        let passageInfos = passageList.map({ (UUID().uuidString, $0) })
        let memos = List<String>()
        memos.append(objectsIn: memoList)
        let passageIDs = List<String>()
        passageIDs.append(objectsIn: passageInfos.map({ $0.0 }))
        let history = RealmHistory(id: historyID, bookID: book.id, memos: memos, passageIDs: passageIDs, createdDate: date)
        
        let realmBook: RealmBook
        if let oldRealmBook = realm.object(ofType: RealmBook.self, forPrimaryKey: book.id) {
            var bookHistoryIDs = [historyID]
            bookHistoryIDs.insert(contentsOf: oldRealmBook.historyIDs, at: 0)
            realmBook = RealmBook(id: book.id, title: book.title, imageURL: book.coverImageURL, createdDate: date,
                                  historyIDs: bookHistoryIDs)
        } else {
            realmBook = RealmBook(id: book.id, title: book.title, imageURL: book.coverImageURL, createdDate: date,
                                  historyIDs: [historyID])
        }
        
        let passages = passageInfos.map({ RealmPassage(id: $0.0, text: $0.1, historyID: historyID) })
        
        try! realm.write {
            realm.create(RealmHistoryOfDate.self, value: historyOfDate, update: .modified)
            realm.create(RealmHistory.self, value: history, update: .modified)
            realm.create(RealmBook.self, value: realmBook, update: .modified)
            realm.add(passages)
        }
    }
}
