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
}
