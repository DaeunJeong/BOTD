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
    func getTodaysPassage()
    func getTodaysPassgeHistoryOfDateID() -> String?
}

public struct HomeViewModel: HomeViewModelProtocol {
    public let repository: HomeRepositoryProtocol
    private let historyOfDates = BehaviorRelay<[String: HistoryOfDate]>(value: [:])
    private let histories = BehaviorRelay<[String: History]>(value: [:])
    private let books = BehaviorRelay<[String: Book]>(value: [:])
    private let todaysPassage = BehaviorRelay<(text: String, historyID: String?)?>(value: nil)
    
    public let sections: Observable<[HomeSection]>
    
    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
        
        sections = Observable.combineLatest(historyOfDates, histories, books, todaysPassage)
            .map({ historyOfDates, histories, books, todaysPassage in
                var sections: [HomeSection] = [.titleHeader([.todaysBookHeader])]
                
                let todayString = DateFormatter(dateFormat: "yyyyMMdd").string(from: Date())
                if let todayHistoryID = historyOfDates[todayString]?.historyIDs.first,
                   let todayHistory = histories[todayHistoryID],
                   let todayBook = books[todayHistory.bookID] {
                    sections += [.todaysBook([.todaysBook(historyOfDateID: todayString, bookImageURL: todayBook.imageURL)])]
                } else {
                    sections += [.todaysBook([.todaysBook(historyOfDateID: nil, bookImageURL: nil)])]
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
                        return HomeCellData.lastWeekHistory(historyOfDateID: dateString, mainBookImageURL: mainBookImageURL,
                                                            historyCount: historyOfDate.historyIDs.count, date: date)
                    } else {
                        return HomeCellData.lastWeekHistory(historyOfDateID: nil, mainBookImageURL: nil, historyCount: 0, date: date)
                    }
                })
                
                sections += [
                    .divider([.divider]),
                    .titleHeader([.titleHeader("지난 7일의 기록")]),
                    .lastWeekHistories(lastWeekHistories),
                    .divider([.divider]),
                    .titleHeader([.titleHeader("오늘의 구절")])
                ]
                if let todaysPassage = todaysPassage {
                    sections += [.todaysPassage([.todaysPassage(passage: todaysPassage.text,
                                                                historyID: todaysPassage.historyID)])]
                }
                
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
        guard let historyOfDate = repository.getHistoryOfDate(id: dateString) else {
            var historyOfDates = historyOfDates.value
            historyOfDates[dateString] = nil
            self.historyOfDates.accept(historyOfDates)
            return
        }
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
    
    public func getTodaysPassage() {
        if let passage = repository.getPassages().randomElement() {
            todaysPassage.accept((passage.text, passage.historyID))
        } else {
            let defaultPassages: [String] = [
                "어른들은 누구나 처음에는 어린이였다. 그러나 그것을 기억하는 어른은 별로 없다.",
                "새는 알에서 나오기 위해 투쟁한다. 알은 세계이다. 태어나려는 자는 하나의 세계를 깨뜨려야 한다. 새는 신에게로 날아간다. 그 신의 이름은 아프락사스다.",
                "부끄럼 많은 생애를 보냈습니다. 저는 인간의 삶이라는 것을 도저히 이해할 수 없습니다.",
                "자네가 무언가를 간절히 원할 때\n온 우주는 자네의 소망이 실현되도록 도와준다네",
                "바다는 비에 젖지 않는다.",
                "삶에 후회를 남기지 말고, 사랑하는데 이유를 달지 마세요.",
                "수백년 동안 졌다고 해서 시작하기도 전에 이기려는 노력도 하지 말아야 할 까닭은 없으니까"
            ]
            todaysPassage.accept((defaultPassages.randomElement() ?? "", nil))
        }
    }
    
    public func getTodaysPassgeHistoryOfDateID() -> String? {
        guard let todaysPassageHistoryID = todaysPassage.value?.historyID else { return nil }
        if let history = histories.value[todaysPassageHistoryID] {
            return DateFormatter(dateFormat: "yyyyMMdd").string(from: history.createdDate)
        } else if let history = repository.getHistory(id: todaysPassageHistoryID) {
            var histories = histories.value
            histories[history.id] = history
            self.histories.accept(histories)
            return DateFormatter(dateFormat: "yyyyMMdd").string(from: history.createdDate)
        } else {
            return nil
        }
    }
}
