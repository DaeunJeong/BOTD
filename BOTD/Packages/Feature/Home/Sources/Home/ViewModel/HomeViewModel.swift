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
                          .divider([.divider])])
    }
}

struct MockTodaysBook: TodaysBookDisplayable {
    var historyID: String { "" }
    var bookImageURL: URL? { URL(string: "https://image.yes24.com/goods/6157159/XL") }
}
