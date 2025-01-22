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
    func getLastWeekHistory()
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
            
            let lastWeekHistories = Array(1...7).map({
                let date = Date(timeIntervalSinceNow: Double(-$0) * 24 * 60 * 60)
                let dateString = DateFormatter(dateFormat: "yyyyMMdd").string(from: date)
                if let historyOfDate = historyOfDates[dateString] {
                    let mainHistoryID = historyOfDate.historyIDs.first
                    let mainBookImageURL: URL? = if let mainHistoryID = mainHistoryID,
                                                    let bookID = histories[mainHistoryID]?.bookID {
                        books[bookID]?.imageURL
                    } else {
                        nil
                    }
                    return HomeCellData.lastWeekHistory(mainHistoryID: mainHistoryID, mainBookImageURL: mainBookImageURL,
                                                        historyCount: historyOfDate.historyIDs.count, date: date)
                } else {
                    return HomeCellData.lastWeekHistory(mainHistoryID: nil, mainBookImageURL: nil, historyCount: 0, date: date)
                }
            })
            
            sections += [
                .divider([.divider]),
                .titleHeader([.titleHeader("지난 7일의 기록")]),
                .lastWeekHistories(lastWeekHistories),
                .divider([.divider]),
                .titleHeader([.titleHeader("오늘의 구절")]),
                .todaysPassage([.todaysPassage(passage: "인간은 파멸당할 수는 있을지 몰라도 패배할 수는 없어", historyID: "")])
            ]
            
            return sections
        })
    }
    
    public func getTodaysHistory() {
        getHistoryIfNeeded(date: Date())
    }
    
    public func getLastWeekHistory() {
        Array(1...7).map({ Date(timeIntervalSinceNow: Double(-$0) * 24 * 60 * 60) }).forEach { date in
            getHistoryIfNeeded(date: date)
        }
    }
    
    private func getHistoryIfNeeded(date: Date) {
        let dateString = DateFormatter(dateFormat: "yyyyMMdd").string(from: date)
        guard let historyOfDate = repository.getHistoryOfDate(id: dateString) else { return }
        var historyOfDates = historyOfDates.value
        historyOfDates[dateString] = historyOfDate
        self.historyOfDates.accept(historyOfDates)
        
        historyOfDate.historyIDs.forEach { historyID in
            guard histories.value[historyID] == nil,
                  let history = repository.getHistory(id: historyID) else { return }
            var histories = histories.value
            histories[historyID] = history
            self.histories.accept(histories)
            
            if books.value[history.bookID] == nil,
               let book = repository.getBook(id: history.bookID) {
                var books = books.value
                books[history.bookID] = book
                self.books.accept(books)
            }
        }
    }
}
