//
//  HistoryDetailViewModel.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/13/25.
//

import Foundation

public protocol HistoryDetailViewModelProtocol {
    
}

public struct HistoryDetailViewModel: HistoryDetailViewModelProtocol {
    private let repository: HistoryDetailRepositoryProtocol
    
    public init(repository: HistoryDetailRepositoryProtocol) {
        self.repository = repository
    }
}
