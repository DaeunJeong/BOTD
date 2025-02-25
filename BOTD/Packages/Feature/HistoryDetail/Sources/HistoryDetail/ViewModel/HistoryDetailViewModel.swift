//
//  HistoryDetailViewModel.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import Foundation
import RxCocoa
import RxSwift
import Entity

public protocol HistoryDetailViewModelProtocol {
    var sections: Observable<[HistoryDetailSection]> { get }
    var naviTitle: Observable<String?> { get }
    
    func getHistoryOfDate()
    func moveToPrevious()
    func moveToNext()
    func getCurrentHistoryID() -> String?
}

public struct HistoryDetailViewModel: HistoryDetailViewModelProtocol {
    public enum Filter {
        case date(historyOfDateID: String)
        case book(bookID: String)
    }
    private let repository: HistoryDetailRepositoryProtocol
    private let filter: Filter
    private let currentHistoryID: BehaviorRelay<String?>
    private let historyIDs = BehaviorRelay<[String]>(value: [])
    private let histories = BehaviorRelay<[String: History]>(value: [:])
    private let books = BehaviorRelay<[String: Book]>(value: [:])
    private let passages = BehaviorRelay<[String: Passage]>(value: [:])
    
    public let sections: Observable<[HistoryDetailSection]>
    public let naviTitle: Observable<String?>
    
    public init(repository: HistoryDetailRepositoryProtocol, filter: Filter, defaultCurrentHistoryID: String? = nil) {
        self.repository = repository
        self.filter = filter
        currentHistoryID = .init(value: defaultCurrentHistoryID)
        
        sections = Observable.combineLatest(currentHistoryID, historyIDs, histories, books, passages)
            .map({ currentHistoryID, historyIDs, histories, books, passages in
                guard let historyID = currentHistoryID, let history = histories[historyID],
                      let book = books[history.bookID] else { return [] }
                
                var sections: [HistoryDetailSection] = []
                switch filter {
                case .date:
                    sections += [
                        .header([.header(title: book.title, isPreviousButtonHidden: historyIDs.first == historyID,
                                         isNextButtonHidden: historyIDs.last == historyID)])
                    ]
                case .book:
                    sections += [
                        .header([.header(title: DateFormatter(dateFormat: "yyyy.M.d (E)").string(from: history.createdDate),
                                         isPreviousButtonHidden: historyIDs.first == historyID,
                                         isNextButtonHidden: historyIDs.last == historyID)])
                    ]
                }
                
                if !history.passageIDs.isEmpty {
                    sections += [
                        .title([.title("기억에 남는 구절")]),
                        .memos(history.passageIDs.compactMap({ passages[$0] }).map({ .memo($0.text) }))
                    ]
                }
                if !history.passageIDs.isEmpty, !history.memos.isEmpty {
                    sections += [.border([.border])]
                }
                if !history.memos.isEmpty {
                    sections += [
                        .title([.title("메모")]),
                        .memos(history.memos.map({ .memo($0) }))
                    ]
                }
                
                return sections
            })
        switch filter {
        case let .date(historyOfDateID):
            if let date = DateFormatter(dateFormat: "yyyyMMdd").date(from: historyOfDateID) {
                naviTitle = .just(DateFormatter(dateFormat: "yyyy.M.d (E)").string(from: date))
            } else {
                naviTitle = .just(nil)
            }
        case let .book(bookID):
            naviTitle = books.map({ $0[bookID]?.title })
        }
    }
    
    public func getHistoryOfDate() {
        switch filter {
        case let .date(historyOfDateID):
            guard let historyOfDate = repository.getHistoryOfDate(id: historyOfDateID) else { return }
            historyIDs.accept(historyOfDate.historyIDs)
            if let currentHistoryID = currentHistoryID.value {
                getHistoryIfNeeded(id: currentHistoryID)
            } else if let firstHistoryID = historyOfDate.historyIDs.first {
                currentHistoryID.accept(firstHistoryID)
                getHistoryIfNeeded(id: firstHistoryID)
            }
        case let .book(bookID):
            guard let book = repository.getBook(id: bookID) else { return }
            historyIDs.accept(book.historyIDs)
            if let currentHistoryID = currentHistoryID.value {
                getHistoryIfNeeded(id: currentHistoryID)
            } else if let firstHistoryID = book.historyIDs.first {
                currentHistoryID.accept(firstHistoryID)
                getHistoryIfNeeded(id: firstHistoryID)
            }
        }
    }
    
    public func moveToPrevious() {
        guard let currentHistoryID = currentHistoryID.value,
              let currentIndex = historyIDs.value.firstIndex(of: currentHistoryID) else { return }
        let previousID = historyIDs.value[currentIndex - 1]
        self.currentHistoryID.accept(previousID)
        getHistoryIfNeeded(id: previousID)
    }
    
    public func moveToNext() {
        guard let currentHistoryID = currentHistoryID.value,
              let currentIndex = historyIDs.value.firstIndex(of: currentHistoryID) else { return }
        let nextID = historyIDs.value[currentIndex + 1]
        self.currentHistoryID.accept(nextID)
        getHistoryIfNeeded(id: nextID)
    }
    
    private func getHistoryIfNeeded(id: String) {
        guard !histories.value.keys.contains(id),
              let history = repository.getHistory(id: id) else { return }
        var histories = self.histories.value
        histories[id] = history
        self.histories.accept(histories)
        
        if !books.value.keys.contains(history.bookID),
           let book = repository.getBook(id: history.bookID) {
            var books = self.books.value
            books[history.bookID] = book
            self.books.accept(books)
        }
        
        var passages = self.passages.value
        history.passageIDs.compactMap { repository.getPassage(id: $0) }.forEach { passage in
            passages[passage.id] = passage
        }
        self.passages.accept(passages)
    }
    
    public func getCurrentHistoryID() -> String? {
        currentHistoryID.value
    }
}
