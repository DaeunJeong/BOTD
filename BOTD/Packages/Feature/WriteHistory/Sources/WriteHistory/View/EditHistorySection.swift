//
//  EditHistorySection.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

import UIKit
import RxDataSources

public enum EditHistorySection {
    case titleHeader([Item])
    case border([Item])
    case memos([Item])
    case memoEmpty([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .border(items): return items
        case let .memos(items): return items
        case let .memoEmpty(items): return items
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
        case .border:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        case .memos:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(242), heightDimension: .absolute(156)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(242), heightDimension: .absolute(156))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 8, bottom: 16, trailing: 8)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .memoEmpty:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension EditHistorySection: SectionModelType {
    public typealias Item = EditHistoryCellData

    public init(original: EditHistorySection, items: [EditHistoryCellData]) {
        switch original {
        case .titleHeader:
            self = .titleHeader(items)
        case .border:
            self = .border(items)
        case .memos:
            self = .memos(items)
        case .memoEmpty:
            self = .memoEmpty(items)
        }
    }
}

public enum EditHistoryCellData {
    case titleHeader(String)
    case border
    case passage(String)
    case addPassage
    case passageEmpty
    case memo(String)
    case addMemo
    case memoEmpty
    
    var cellStyle: EditHistoryCellProtocol.Type {
        switch self {
        case .titleHeader: WriteHistoryTitleHeaderCell.self
        case .border: WriteHistoryBorderCell.self
        case .passage, .memo: WriteHistoryMemoCell.self
        case .addPassage, .addMemo: WriteHistoryAddMemoCell.self
        case .passageEmpty, .memoEmpty: WriteHistoryMemoEmptyCell.self
        }
    }
}

public protocol EditHistoryCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: EditHistoryCellData)
}


