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
    var isEnabledToComplete: Observable<Bool> { get }
    
    func selectDate(_ date: Date)
    func selectBook(_ book: SearchBookResultDisplayable)
    func addPassage(_ passage: String)
    func deletePassage(index: Int)
    func addMemo(_ memo: String)
    func deleteMemo(index: Int)
    func writeHistory()
}

public struct WriteHistoryViewModel: WriteHistoryViewModelProtocol {
    private let repository: WriteHistoryRepositoryProtocol
    private let selectedDate: BehaviorRelay<Date>
    private let selectedBook = BehaviorRelay<SearchBookResultDisplayable?>(value: nil)
    private let passageList = BehaviorRelay<[String]>(value: [])
    private let memoList = BehaviorRelay<[String]>(value: [])
    
    public let sections: Observable<[WriteHistorySection]>
    public let isEnabledToComplete: Observable<Bool>
    
    public init(repository: WriteHistoryRepositoryProtocol, defaultDate: Date = Date()) {
        selectedDate = .init(value: defaultDate)
        self.repository = repository
        sections = Observable.combineLatest(selectedDate, selectedBook, passageList, memoList)
            .map({ selectedDate, selectedBook, passageList, memoList in
                var sections: [WriteHistorySection] = [.titleHeader([.titleHeader("날짜")]),
                                                       .inputField([.dateInputField(selectedDate: selectedDate)]),
                                                       .border([.border]),
                                                       .titleHeader([.titleHeader("책 제목")]),
                                                       .inputField([.bookTitleInputField(text: selectedBook?.title)]),
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
        isEnabledToComplete = Observable.combineLatest(selectedBook, passageList, memoList)
            .map({ $0 != nil && (!$1.isEmpty || !$2.isEmpty) })
    }
    
    public func selectDate(_ date: Date) {
        selectedDate.accept(date)
    }
    
    public func selectBook(_ book: SearchBookResultDisplayable) {
        selectedBook.accept(book)
    }
    
    public func addPassage(_ passage: String) {
        passageList.accept(passageList.value + [passage])
    }
    
    public func deletePassage(index: Int) {
        var passageList = passageList.value
        passageList.remove(at: index)
        self.passageList.accept(passageList)
    }
    
    public func addMemo(_ memo: String) {
        memoList.accept(memoList.value + [memo])
    }
    
    public func deleteMemo(index: Int) {
        var memoList = memoList.value
        memoList.remove(at: index)
        self.memoList.accept(memoList)
    }
    
    public func writeHistory() {
        guard let book = selectedBook.value else { return }
        repository.writeHistory(date: selectedDate.value, book: book, memoList: memoList.value, passageList: passageList.value)
    }
}
