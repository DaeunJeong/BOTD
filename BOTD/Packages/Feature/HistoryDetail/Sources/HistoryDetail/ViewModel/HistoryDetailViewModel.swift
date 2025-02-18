//
//  HistoryDetailViewModel.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import Foundation
import RxSwift

public protocol HistoryDetailViewModelProtocol {
    var sections: Observable<[HistoryDetailSection]> { get }
}

public struct HistoryDetailViewModel: HistoryDetailViewModelProtocol {
    private let repository: HistoryDetailRepositoryProtocol
    
    public let sections: Observable<[HistoryDetailSection]>
    
    public init(repository: HistoryDetailRepositoryProtocol, historyOfDateID: String) {
        self.repository = repository
        
        sections = .just([.header([.header(title: "노인과 바다", isPreviousButtonHidden: false, isNextButtonHidden: false)]),
                          .title([.title("기억에 남는 구절")]),
                          .memos([.memo("zz")]),
                          .border([.border]),
                          .title([.title("메모")]),
                          .memos([.memo("zbb")])])
    }
}
