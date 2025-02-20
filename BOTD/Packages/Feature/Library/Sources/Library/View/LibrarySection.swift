//
//  LibrarySection.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import UIKit
import RxDataSources

public enum LibrarySection {
    case titleHeader([Item])
    case books([Item])
    case empty([Item])
    
    public var items: [Item] {
        switch self {
        case let .titleHeader(items): return items
        case let .books(items): return items
        case let .empty(items): return items
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
        case .books:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 3 * 1.33))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(16)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 32, leading: 16, bottom: 32, trailing: 16)
            section.interGroupSpacing = 16
            return section
        case .empty:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension LibrarySection: SectionModelType {
    public typealias Item = LibraryCellData

    public init(original: LibrarySection, items: [LibraryCellData]) {
        switch original {
        case .titleHeader:
            self = .titleHeader(items)
        case .books:
            self = .books(items)
        case .empty:
            self = .empty(items)
        }
    }
}

public enum LibraryCellData {
    case titleHeader
    case book(bookID: String, imageURL: URL?)
    case addBook
    case empty
    
    var cellStyle: LibraryCellProtocol.Type {
        switch self {
        case .titleHeader: LibraryTitleHeaderCell.self
        case .book: LibraryBookCell.self
        case .addBook: LibraryAddBookCell.self
        case .empty: LibraryEmptyCell.self
        }
    }
}

public protocol LibraryCellProtocol: AnyObject {
    @MainActor
    func apply(cellData: LibraryCellData)
}

