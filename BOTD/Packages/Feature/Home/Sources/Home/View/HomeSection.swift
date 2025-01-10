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
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .todaysBook(items): return items
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
        }
    }
}

public enum HomeCellData {
    case todaysBookHeader
    case todaysBook(TodaysBookDisplayable?)
    
    var cellStyle: HomeCellProtocol.Type {
        switch self {
        case .todaysBookHeader: HomeTitleHeaderCell.self
        case .todaysBook: HomeTodaysBookCell.self
        }
    }
}

public protocol HomeCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: HomeCellData)
}

