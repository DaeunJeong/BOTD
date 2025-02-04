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
    case memos([Item])
    case memoEmpty([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .inputField(items): return items
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
        case .memos:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(210), heightDimension: .absolute(140)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(140))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 8, leading: 16, bottom: 24, trailing: 16)
            section.interGroupSpacing = 10
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
        case .memos:
            self = .memos(items)
        case .memoEmpty:
            self = .memoEmpty(items)
        }
    }
}

public enum WriteHistoryCellData {
    case titleHeader(String)
    case dateInputField(selectedDate: Date)
    case border
    case bookTitleInputField(text: String?)
    case passage(String)
    case addPassage
    case passageEmpty
    case memo(String)
    case addMemo
    case memoEmpty
    
    var cellStyle: WriteHistoryCellProtocol.Type {
        switch self {
        case .titleHeader: WriteHistoryTitleHeaderCell.self
        case .dateInputField, .bookTitleInputField: WriteHistoryInputFieldCell.self
        case .border: WriteHistoryBorderCell.self
        case .passage, .memo: WriteHistoryMemoCell.self
        case .addPassage, .addMemo: WriteHistoryAddMemoCell.self
        case .passageEmpty, .memoEmpty: WriteHistoryMemoEmptyCell.self
        }
    }
}

public protocol WriteHistoryCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: WriteHistoryCellData)
}

