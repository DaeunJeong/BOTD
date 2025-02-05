//
//  SearchBookViewModel.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

public protocol SearchBookViewModelProtocol {
    var sections: Observable<[SearchBookSection]> { get }
}

public struct SearchBookViewModel: SearchBookViewModelProtocol {
    public let sections: Observable<[SearchBookSection]>
    
    public init() {
        sections = .just([.results([.result(MockSearchBookResult()), .result(MockSearchBookResult())])])
    }
}

struct MockSearchBookResult: SearchBookResultDisplayable {
    let title: String = "제목"
    let author: String = "지은이"
    let publisher: String = "출판사"
    let description: String = "설명"
    let coverImageURL: URL? = nil
}
