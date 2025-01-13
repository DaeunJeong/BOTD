//
//  HomeViewModel.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import Foundation
import RxSwift

public protocol HomeViewModelProtocol {
    var sections: Observable<[HomeSection]> { get }
}

public struct HomeViewModel: HomeViewModelProtocol {
    public let sections: Observable<[HomeSection]>
    
    public init() {
        sections = .just([.titleHeader([.todaysBookHeader]),
                          .todaysBook([.todaysBook(MockTodaysBook())]),
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
                          .todaysPassage([.todaysPassage(passage: "인간은 파멸당할 수는 있을지 몰라도 패배할 수는 없어", historyID: "")])])
    }
}

struct MockTodaysBook: TodaysBookDisplayable {
    var historyID: String { "" }
    var bookImageURL: URL? { URL(string: "https://image.yes24.com/goods/6157159/XL") }
}

struct MockLastWeekHistory: HomeLastWeekHistoryDisplayable {
    var historyID: String { "" }
    var mainBookImageURL: URL? { URL(string: "https://image.yes24.com/goods/6157159/XL") }
    var bookCount: Int { 2 }
}
