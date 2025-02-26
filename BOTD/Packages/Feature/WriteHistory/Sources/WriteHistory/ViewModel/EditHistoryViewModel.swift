//
//  EditHistoryViewModel.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

import Foundation
import RxCocoa
import RxSwift
import EventBus

public protocol EditHistoryViewModelProtocol {
    var sections: Observable<[EditHistorySection]> { get }
    var isEnabledToComplete: Observable<Bool> { get }
    
    func getHistory()
    func addPassage(_ passage: String)
    func deletePassage(index: Int)
    func addMemo(_ memo: String)
    func deleteMemo(index: Int)
    func editHistory()
}

public struct EditHistoryViewModel: EditHistoryViewModelProtocol {
    private let repository: EditHistoryRepositoryProtocol
    private let historyID: String
    private let passageList = BehaviorRelay<[String]>(value: [])
    private let memoList = BehaviorRelay<[String]>(value: [])
    
    public let sections: Observable<[EditHistorySection]>
    public let isEnabledToComplete: Observable<Bool>
    
    public init(repository: EditHistoryRepositoryProtocol, historyID: String) {
        self.repository = repository
        self.historyID = historyID
        sections = Observable.combineLatest(passageList, memoList)
            .map({ passageList, memoList in
                var sections: [EditHistorySection] = [.titleHeader([.titleHeader("기억에 남는 구절")])]
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
        isEnabledToComplete = Observable.combineLatest(passageList, memoList)
            .map({ !$0.isEmpty || !$1.isEmpty })
    }
    
    public func getHistory() {
        guard let history = repository.getHistory(id: historyID) else { return }
        let passageList = history.passageIDs.compactMap({ repository.getPassage(id: $0)?.text })
        self.passageList.accept(passageList)
        memoList.accept(history.memos)
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
    
    public func editHistory() {
        repository.editHistory(historyID: historyID, passageList: passageList.value, memoList: memoList.value)
    }
}
