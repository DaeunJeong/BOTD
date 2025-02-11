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
    func selectBook(_ book: SearchBookResultDisplayable)
    func addPassage(_ passage: String)
    func addMemo(_ memo: String)
}

public struct WriteHistoryViewModel: WriteHistoryViewModelProtocol {
    private let selectedDate = BehaviorRelay<Date>(value: Date())
    private let bookTitle = BehaviorRelay<String?>(value: nil)
    private let passageList = BehaviorRelay<[String]>(value: [])
    private let memoList = BehaviorRelay<[String]>(value: [])
    
    public let sections: Observable<[WriteHistorySection]>
    
    public init() {
        sections = Observable.combineLatest(selectedDate, bookTitle, passageList, memoList)
            .map({ selectedDate, bookTitle, passageList, memoList in
                var sections: [WriteHistorySection] = [.titleHeader([.titleHeader("날짜")]),
                                                       .inputField([.dateInputField(selectedDate: selectedDate)]),
                                                       .border([.border]),
                                                       .titleHeader([.titleHeader("책 제목")]),
                                                       .inputField([.bookTitleInputField(text: bookTitle)]),
                                                       .border([.border]),
                                                       .titleHeader([.titleHeader("기억에 남는 구절")])]
                if passageList.isEmpty {
                    sections += [.memoEmpty([.passageEmpty])]
                } else {
                    sections += [.memos(passageList.map({ .passage($0) }) + [.addPassage])]
                }
                sections += [.border([.border]),
                             .titleHeader([.titleHeader("메모")])]
                
                if memoList.isEmpty {
                    sections += [.memoEmpty([.memoEmpty])]
                } else {
                    sections += [.memos(memoList.map({ .memo($0) }) + [.addMemo])]
                }
                
                return sections
            })
    }
    
    public func selectDate(_ date: Date) {
        selectedDate.accept(date)
    }
    
    public func selectBook(_ book: SearchBookResultDisplayable) {
        bookTitle.accept(book.title)
    }
    
    public func addPassage(_ passage: String) {
        passageList.accept(passageList.value + [passage])
    }
    
    public func addMemo(_ memo: String) {
        memoList.accept(memoList.value + [memo])
    }
}
