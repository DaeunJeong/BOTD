//
//  WriteHistoryViewModel.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import Foundation
import RxCocoa
import RxSwift

public protocol WriteHistoryViewModelProtocol {
    var sections: Observable<[WriteHistorySection]> { get }
    
    func selectDate(_ date: Date)
    func selectBook()
}

public struct WriteHistoryViewModel: WriteHistoryViewModelProtocol {
    private let selectedDate = BehaviorRelay<Date>(value: Date())
    private let bookTitle = BehaviorRelay<String?>(value: nil)
    
    public let sections: Observable<[WriteHistorySection]>
    
    public init() {
        sections = Observable.combineLatest(selectedDate, bookTitle)
            .map({ selectedDate, bookTitle in
                return [.titleHeader([.titleHeader("날짜")]),
                        .inputField([.dateInputField(selectedDate: selectedDate)]),
                        .border([.border]),
                        .titleHeader([.titleHeader("책 제목")]),
                        .inputField([.bookTitleInputField(text: bookTitle)]),
                        .border([.border])]
            })
    }
    
    public func selectDate(_ date: Date) {
        selectedDate.accept(date)
    }
    
    public func selectBook() {
        bookTitle.accept("책 제목")
    }
}
