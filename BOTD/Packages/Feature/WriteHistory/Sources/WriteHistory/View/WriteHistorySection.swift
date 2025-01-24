//
//  WriteHistorySection.swift
//  WriteHistory
//
//  Created by 정다은 on 1/24/25.
//

import UIKit
import RxDataSources

public enum WriteHistorySection {
    case titleHeader([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        }
    }
    
    @MainActor
    public var layoutSize: NSCollectionLayoutSection {
        switch self {
        case .titleHeader:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension WriteHistorySection: SectionModelType {
    public typealias Item = WriteHistoryCellData

    public init(original: WriteHistorySection, items: [WriteHistoryCellData]) {
        switch original {
        case .titleHeader:
            self = .titleHeader(items)
        }
    }
}

public enum WriteHistoryCellData {
    case titleHeader(String)
    
    var cellStyle: WriteHistoryCellProtocol.Type {
        switch self {
        case .titleHeader: WriteHistoryTitleHeaderCell.self
        }
    }
}

public protocol WriteHistoryCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: WriteHistoryCellData)
}

