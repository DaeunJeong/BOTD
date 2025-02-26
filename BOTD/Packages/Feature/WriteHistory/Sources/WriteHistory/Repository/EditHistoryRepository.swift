//
//  EditHistoryRepository.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

import Foundation
import RealmSwift
import Entity

public protocol EditHistoryRepositoryProtocol {
    func getHistory(id: String) -> History?
    func getPassage(id: String) -> Passage?
    func editHistory(historyID: String, passageList: [String], memoList: [String])
    func deleteHistory(historyID: String)
}

public struct EditHistoryRepository: EditHistoryRepositoryProtocol {
    let realm: Realm
    
    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    public func getHistory(id: String) -> History? {
        realm.object(ofType: RealmHistory.self, forPrimaryKey: id)?.convertToModel()
    }
    
    public func getPassage(id: String) -> Passage? {
        realm.object(ofType: RealmPassage.self, forPrimaryKey: id)?.convertToModel()
    }
    
    public func editHistory(historyID: String, passageList: [String], memoList: [String]) {
        guard let history = realm.object(ofType: RealmHistory.self, forPrimaryKey: historyID) else { return }
        let originalPassages = history.passageIDs.compactMap({ realm.object(ofType: RealmPassage.self, forPrimaryKey: $0) })
        let newPassageList = passageList.map({ RealmPassage(id: UUID().uuidString, text: $0, historyID: historyID) })
        let realmPassageIDs = List<String>()
        realmPassageIDs.append(objectsIn: newPassageList.map({ $0.id }))
        let realmMemos = List<String>()
        realmMemos.append(objectsIn: memoList)
        
        try! realm.write {
            history.passageIDs = realmPassageIDs
            history.memos = realmMemos
            originalPassages.forEach({ realm.delete($0) })
            newPassageList.forEach({ realm.add($0) })
        }
    }
    
    public func deleteHistory(historyID: String) {
        guard let history = realm.object(ofType: RealmHistory.self, forPrimaryKey: historyID),
                let book = realm.object(ofType: RealmBook.self, forPrimaryKey: history.bookID) else { return }
        let historyOfDateID = DateFormatter(dateFormat: "yyyyMMdd").string(from: history.createdDate)
        guard let historyOfDate = realm.object(ofType: RealmHistoryOfDate.self, forPrimaryKey: historyOfDateID) else { return }
        let originalPassages = history.passageIDs.compactMap({ realm.object(ofType: RealmPassage.self, forPrimaryKey: $0) })
        try! realm.write {
            originalPassages.forEach({ realm.delete($0) })
            if historyOfDate.historyIDs.count > 1,
               let index = historyOfDate.historyIDs.map({ $0 }).firstIndex(of: historyID) {
                historyOfDate.historyIDs.remove(at: index)
            } else {
                realm.delete(historyOfDate)
            }
            if book.historyIDs.count > 1,
               let index = book.historyIDs.map({ $0 }).firstIndex(of: historyID) {
                book.historyIDs.remove(at: index)
            } else {
                realm.delete(book)
            }
            realm.delete(history)
        }
    }
}
