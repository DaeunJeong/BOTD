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
}

public struct WriteHistoryViewModel: WriteHistoryViewModelProtocol {
    private let selectedDate = BehaviorRelay<Date>(value: Date())
    
    public let sections: Observable<[WriteHistorySection]>
    
    public init() {
        sections = selectedDate.map({ selectedDate in
            return [.titleHeader([.titleHeader("날짜")]),
                    .inputField([.dateInputField(selectedDate: selectedDate)]),
                    .border([.border])]
        })
    }
    
    public func selectDate(_ date: Date) {
        selectedDate.accept(date)
    }
}
