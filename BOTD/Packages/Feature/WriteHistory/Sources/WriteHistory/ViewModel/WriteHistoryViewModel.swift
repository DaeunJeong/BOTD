//
//  WriteHistoryViewModel.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import Foundation
import RxSwift

public protocol WriteHistoryViewModelProtocol {
    var sections: Observable<[WriteHistorySection]> { get }
}

public struct WriteHistoryViewModel: WriteHistoryViewModelProtocol {
    public let sections: Observable<[WriteHistorySection]>
    
    public init() {
        sections = .just([.titleHeader([.titleHeader("날짜")])])
    }
}
