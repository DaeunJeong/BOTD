//
//  SearchBookViewModel.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import Entity

public protocol SearchBookViewModelProtocol {
    var searchQuery: BehaviorRelay<String?> { get }
    var sections: Observable<[SearchBookSection]> { get }
    var isShownIndicator: Observable<Bool> { get }
    var errorOccured: Observable<Void> { get }
    
    func search(isPagination: Bool) async
}

public struct SearchBookViewModel: SearchBookViewModelProtocol {
    private let repository: SearchBookRepositoryProtocol
    public let searchQuery = BehaviorRelay<String?>(value: nil)
    private let bookResults = BehaviorRelay<[AladinBook]>(value: [])
    private let needToPagination = BehaviorRelay<Bool>(value: false)
    private let isRequesting = BehaviorRelay<Bool>(value: false)
    private let isNeededToShowIndicator = BehaviorRelay<Bool>(value: false)
    private let page = BehaviorRelay<Int>(value: 1)
    private let limit: Int = 10
    private let error = PublishRelay<Error>()
    
    public let sections: Observable<[SearchBookSection]>
    public let isShownIndicator: Observable<Bool>
    public let errorOccured: Observable<Void>
    
    public init(repository: SearchBookRepositoryProtocol) {
        self.repository = repository
        sections = Observable.combineLatest(searchQuery, bookResults, needToPagination)
            .map({ searchQuery, bookResults, needToPagination in
                if let searchQuery = searchQuery, !searchQuery.isEmpty {
                    if bookResults.isEmpty {
                        return [.empty([.empty(title: "검색 결과가 없습니다")])]
                    } else {
                        return [.results(bookResults.map({ .result($0) }))]
                            + (needToPagination ? [.loading([.loading])] : [])
                    }
                } else {
                    return [.empty([.empty(title: "검색어를 입력해 주세요")])]
                }
            })
        isShownIndicator = isNeededToShowIndicator.asObservable()
        errorOccured = error.map({ _ in })
    }
    
    public func search(isPagination: Bool) async {
        guard !isRequesting.value,
              let searchQuery = searchQuery.value, !searchQuery.isEmpty else { return }
        isRequesting.accept(true)
        if !isPagination {
            isNeededToShowIndicator.accept(true)
        }
        page.accept(isPagination ? (page.value + 1) : 1)
        
        do {
            let books = try await repository.getBooks(searchQuery: searchQuery, page: page.value)
            if isPagination {
                bookResults.accept(bookResults.value + books)
            } else {
                bookResults.accept(books)
            }
            needToPagination.accept(books.count == limit)
        } catch {
            if !isPagination {
                self.error.accept(error)
            }
        }
        isRequesting.accept(false)
        isNeededToShowIndicator.accept(false)
    }
}

extension AladinBook: SearchBookResultDisplayable {    }
