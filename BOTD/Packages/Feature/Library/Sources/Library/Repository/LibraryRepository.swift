//
//  LibraryRepository.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import Foundation
import RealmSwift
import Entity

public protocol LibraryRepositoryProtocol {
    func getBooks() -> [Book]
}

public struct LibraryRepository: LibraryRepositoryProtocol {
    private let realm: Realm
    
    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    public func getBooks() -> [Book] {
        realm.objects(RealmBook.self).map({ $0.convertToModel() })
    }
}
