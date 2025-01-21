//
//  HomeRepository.swift
//  Home
//
//  Created by 정다은 on 1/21/25.
//

import Foundation
import RealmSwift
import Entity

public protocol HomeRepositoryProtocol {
    func getHistoryOfDate(id: String) -> HistoryOfDate?
    func getHistory(id: String) -> History?
    func getBook(id: String) -> Book?
}

public struct HomeRepository: HomeRepositoryProtocol {
    let realm: Realm
    
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
}
