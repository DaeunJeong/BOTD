//
//  LibraryViewModel.swift
//  Library
//
//  Created by 정다은 on 2/20/25.
//

import Foundation
import RxCocoa
import RxSwift

public protocol LibraryViewModelProtocol {
    var sections: Observable<[LibrarySection]> { get }
}

public struct LibraryViewModel: LibraryViewModelProtocol {
    public let sections: Observable<[LibrarySection]>
    
    public init() {
        sections = .just([.titleHeader([.titleHeader]),
                          .empty([.empty])])
    }
}
