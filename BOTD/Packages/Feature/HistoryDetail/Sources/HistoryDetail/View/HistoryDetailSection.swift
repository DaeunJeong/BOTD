//
//  HistoryDetailSection.swift
//  HistoryDetail
//
//  Created by 정다은 on 2/18/25.
//

import UIKit
import RxDataSources

public enum HistoryDetailSection {
    case header([Item])
    case memos([Item])
    case title([Item])
    case border([Item])
    
    public var items: [Item] {
        switch self {
        case let .header(items): return items
        case let .memos(items): return items
        case let .title(items): return items
        case let .border(items): return items
        }
    }
    
    @MainActor
    public var layoutSize: NSCollectionLayoutSection {
        switch self {
        case .header:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
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
        case .title:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(64)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(64))
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

extension HistoryDetailSection: SectionModelType {
    public typealias Item = HistoryDetailCellData

    public init(original: HistoryDetailSection, items: [HistoryDetailCellData]) {
        switch original {
        case .header:
            self = .header(items)
        case .memos:
            self = .memos(items)
        case .title:
            self = .title(items)
        case .border:
            self = .border(items)
        }
    }
}

public enum HistoryDetailCellData {
    case header(title: String, isPreviousButtonHidden: Bool, isNextButtonHidden: Bool)
    case memo(String)
    case title(String)
    case border
    
    var cellStyle: HistoryDetailCellProtocol.Type {
        switch self {
        case .header: HistoryDetailHeaderCell.self
        case .memo: HistoryDetailMemoCell.self
        case .title: HistoryDetailTitleCell.self
        case .border: HistoryDetailBorderCell.self
        }
    }
}

public protocol HistoryDetailCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: HistoryDetailCellData)
}

