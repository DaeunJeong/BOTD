//
//  SearchBookRepository.swift
//  WriteHistory
//
//  Created by 정다은 on 2/7/25.
//

import Foundation
import Entity
import Service

public protocol SearchBookRepositoryProtocol {
    func getBooks(searchQuery: String, page: Int) async throws -> [AladinBook]
}

public struct SearchBookRepository: SearchBookRepositoryProtocol {
    private let service: AladinServiceProtocol
    
    public init(service: AladinServiceProtocol) {
        self.service = service
    }
    
    public func getBooks(searchQuery: String, page: Int) async throws -> [AladinBook] {
        return try await service.getBooks(searchQuery: searchQuery, page: page)
    }
}
