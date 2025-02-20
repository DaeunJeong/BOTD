//
//  LibraryViewModel.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import Foundation
import RxCocoa
import RxSwift
import Entity

public protocol LibraryViewModelProtocol {
    var sections: Observable<[LibrarySection]> { get }
    
    func getBooks()
}

public struct LibraryViewModel: LibraryViewModelProtocol {
    private let repository: LibraryRepositoryProtocol
    private let books = BehaviorRelay<[String: Book]>(value: [:])
    
    public let sections: Observable<[LibrarySection]>
    
    public init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
        
        sections = books.map({ books in
            var sections: [LibrarySection] = [.titleHeader([.titleHeader])]
            let sortedBooks = books.values.sorted(by: { $0.createdDate > $1.createdDate })
            if sortedBooks.isEmpty {
                sections += [.empty([.empty])]
            } else {
                sections += [.books(sortedBooks.map({ .book(bookID: $0.id, imageURL: $0.imageURL) }) + [.addBook])]
            }
            return sections
        })
    }
    
    public func getBooks() {
        var books: [String: Book] = [:]
        repository.getBooks().forEach { book in
            books[book.id] = book
        }
        self.books.accept(books)
    }
}
