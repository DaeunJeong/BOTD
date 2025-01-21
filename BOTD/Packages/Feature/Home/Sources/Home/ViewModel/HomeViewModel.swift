//
//  HomeViewModel.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import Foundation
import RxCocoa
import RxSwift
import Entity

public protocol HomeViewModelProtocol {
    var sections: Observable<[HomeSection]> { get }
    
    func getTodaysHistory()
}

public struct HomeViewModel: HomeViewModelProtocol {
    public let repository: HomeRepositoryProtocol
    private let historyOfDates = BehaviorRelay<[String: HistoryOfDate]>(value: [:])
    private let histories = BehaviorRelay<[String: History]>(value: [:])
    private let books = BehaviorRelay<[String: Book]>(value: [:])
    
    public let sections: Observable<[HomeSection]>
    
    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        
        sections = Observable.combineLatest(historyOfDates, histories, books).map({ historyOfDates, histories, books in
            var sections: [HomeSection] = [.titleHeader([.todaysBookHeader])]
            
            let todayString = DateFormatter(dateFormat: "yyyyMMdd").string(from: Date())
            if let todayHistoryID = historyOfDates[todayString]?.historyIDs.first,
               let todayHistory = histories[todayHistoryID],
               let todayBook = books[todayHistory.bookID] {
                sections += [.todaysBook([.todaysBook(historyID: todayHistoryID, bookImageURL: todayBook.imageURL)])]
            } else {
                sections += [.todaysBook([.todaysBook(historyID: nil, bookImageURL: nil)])]
            }
            sections += [
                .divider([.divider]),
                .titleHeader([.titleHeader("지난 7일의 기록")]),
                .lastWeekHistories([.lastWeekHistory(history: MockLastWeekHistory(), date: Date(timeIntervalSinceNow: 0)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: -72 * 60 * 60)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: 0)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: 0)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: 0)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: 0)),
                                    .lastWeekHistory(history: nil, date: Date(timeIntervalSinceNow: 0))]),
                .divider([.divider]),
                .titleHeader([.titleHeader("오늘의 구절")]),
                .todaysPassage([.todaysPassage(passage: "인간은 파멸당할 수는 있을지 몰라도 패배할 수는 없어", historyID: "")])
            ]
            
            return sections
        })
    }
    
    public func getTodaysHistory() {
        let todayString = DateFormatter(dateFormat: "yyyyMMdd").string(from: Date())
        guard let historyOfDate = repository.getHistoryOfDate(id: todayString),
              let todaysHistoryID = historyOfDate.historyIDs.first else { return }
        var historyOfDates = historyOfDates.value
        historyOfDates[todayString] = historyOfDate
        self.historyOfDates.accept(historyOfDates)
        
        if let todaysHistory = repository.getHistory(id: todaysHistoryID) {
            var histories = histories.value
            histories[todaysHistoryID] = todaysHistory
            self.histories.accept(histories)
            
            if let todaysHistoryBook = repository.getBook(id: todaysHistory.bookID) {
                var books = books.value
                books[todaysHistory.bookID] = todaysHistoryBook
                self.books.accept(books)
            }
        }
    }
}

struct MockLastWeekHistory: HomeLastWeekHistoryDisplayable {
    var historyID: String { "" }
    var mainBookImageURL: URL? { URL(string: "https://image.yes24.com/goods/6157159/XL") }
    var bookCount: Int { 2 }
}
