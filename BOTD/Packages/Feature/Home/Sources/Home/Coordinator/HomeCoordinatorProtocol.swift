//
//  HomeCoordinatorProtocol.swift
//  Home
//
//  Created by 정다은 on 1/24/25.
//

import UIKit

public protocol HomeCoordinatorProtocol {
    @MainActor func presentWriteHistoryVC(defaultDate: Date)
    func presentHistoryDetailVC(historyOfDateID: String, defaultCurrentHistoryID: String?)
}
