//
//  HistoryDetailRepository.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import Foundation
import RealmSwift
import Entity

public protocol HistoryDetailRepositoryProtocol {
    func getHistoryOfDate(id: String) -> HistoryOfDate?
    func getHistory(id: String) -> History?
    func getBook(id: String) -> Book?
    func getPassage(id: String) -> Passage?
}

public struct HistoryDetailRepository: HistoryDetailRepositoryProtocol {
    private let realm: Realm
    
    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    public func getHistoryOfDate(id: String) -> HistoryOfDate? {
        realm.object(ofType: RealmHistoryOfDate.self, forPrimaryKey: id)?.convertToModel()
    }
    
    public func getHistory(id: String) -> History? {
        realm.object(ofType: RealmHistory.self, forPrimaryKey: id)?.convertToModel()
    }
    
    public func getBook(id: String) -> Book? {
        realm.object(ofType: RealmBook.self, forPrimaryKey: id)?.convertToModel()
    }
    
    public func getPassage(id: String) -> Passage? {
        realm.object(ofType: RealmPassage.self, forPrimaryKey: id)?.convertToModel()
    }
}
