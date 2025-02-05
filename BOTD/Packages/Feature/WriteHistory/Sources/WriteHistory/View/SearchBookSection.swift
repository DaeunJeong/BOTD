//
//  SearchBookSection.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import UIKit
import RxDataSources

public enum SearchBookSection {
    case empty([Item])
    case results([Item])
    
    public var items: [Item] {
        switch self {
        case let .empty(items): return items
        case let .results(items): return items
        }
    }
    
    @MainActor
    public var layoutSize: NSCollectionLayoutSection {
        switch self {
        case .empty:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        case .results:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(208)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(208))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension SearchBookSection: SectionModelType {
    public typealias Item = SearchBookCelData

    public init(original: SearchBookSection, items: [SearchBookCelData]) {
        switch original {
        case .empty:
            self = .empty(items)
        case .results:
            self = .results(items)
        }
    }
}

public enum SearchBookCelData {
    case empty(title: String)
    case result(SearchBookResultDisplayable)
    
    var cellStyle: SearchBookCellProtocol.Type {
        switch self {
        case .empty: return SearchBookEmptyCell.self
        case .result: return SearchBookResultCell.self
        }
    }
}

public protocol SearchBookCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: SearchBookCelData)
}

