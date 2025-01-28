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
    case inputField([Item])
    case border([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .inputField(items): return items
        case let .border(items): return items
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
        case .inputField:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        case .border:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
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
        case .inputField:
            self = .inputField(items)
        case .border:
            self = .border(items)
        }
    }
}

public enum WriteHistoryCellData {
    case titleHeader(String)
    case dateInputField(selectedDate: Date)
    case border
    
    var cellStyle: WriteHistoryCellProtocol.Type {
        switch self {
        case .titleHeader: WriteHistoryTitleHeaderCell.self
        case .dateInputField: WriteHistoryInputFieldCell.self
        case .border: WriteHistoryBorderCell.self
        }
    }
}

public protocol WriteHistoryCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: WriteHistoryCellData)
}

