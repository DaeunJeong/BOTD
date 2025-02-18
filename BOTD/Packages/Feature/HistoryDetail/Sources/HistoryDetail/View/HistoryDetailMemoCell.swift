//
//  HistoryDetailMemoCell.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/18/25.
//

import UIKit
import CommonUI

public final class HistoryDetailMemoCell: MemoCell, HistoryDetailCellProtocol {
    public func apply(cellData: HistoryDetailCellData) {
        guard case let .memo(text) = cellData else { return }
        apply(text: text)
    }
}
