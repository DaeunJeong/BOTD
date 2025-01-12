//
//  HomeSection.swift
//  Home
//
//  Created by 정다은 on 1/10/25.
//

import UIKit
import RxDataSources

public enum HomeSection {
    case titleHeader([Item])
    case todaysBook([Item])
    case divider([Item])
    case lastWeekHistories([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .todaysBook(items): return items
        case let .divider(items): return items
        case let .lastWeekHistories(items): return items
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
        case .todaysBook:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(224)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(224))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        case .divider:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        case .lastWeekHistories:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(182)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(182))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(16)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 24, leading: 24, bottom: 32, trailing: 24)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}

extension HomeSection: SectionModelType {
    public typealias Item = HomeCellData

    public init(original: HomeSection, items: [HomeCellData]) {
        switch original {
        case .titleHeader:
            self = .titleHeader(items)
        case .todaysBook:
            self = .todaysBook(items)
        case .divider:
            self = .divider(items)
        case .lastWeekHistories:
            self = .lastWeekHistories(items)
        }
    }
}

public enum HomeCellData {
    case todaysBookHeader
    case todaysBook(TodaysBookDisplayable?)
    case divider
    case titleHeader(String)
    case lastWeekHistory(history: HomeLastWeekHistoryDisplayable?, date: Date)
    
    var cellStyle: HomeCellProtocol.Type {
        switch self {
        case .todaysBookHeader: HomeTitleHeaderCell.self
        case .todaysBook: HomeTodaysBookCell.self
        case .divider: HomeDividerCell.self
        case .titleHeader: HomeTitleHeaderCell.self
        case .lastWeekHistory: HomeLastWeekHistoryCell.self
        }
    }
}

public protocol HomeCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: HomeCellData)
}

