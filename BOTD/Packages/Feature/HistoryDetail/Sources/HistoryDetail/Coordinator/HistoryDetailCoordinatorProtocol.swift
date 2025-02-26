//
//  HistoryDetailCoordinatorProtocol.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/25/25.
//

import UIKit

public protocol HistoryDetailCoordinatorProtocol {
    @MainActor func presentEditHistoryVC(historyID: String, completeToEditHandler: @escaping () -> Void,
                                         completeToDeleteHandler: @escaping () -> Void)
}
