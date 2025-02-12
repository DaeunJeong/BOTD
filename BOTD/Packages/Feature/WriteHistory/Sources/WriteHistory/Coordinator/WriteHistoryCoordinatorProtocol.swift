//
//  WriteHistoryCoordinatorProtocol.swift
//  WriteHistory
//
//  Created by 정다은 on 2/5/25.
//

public protocol WriteHistoryCoordinatorProtocol {
    func pushSearchBookVC(bookSelectedHandler: @escaping (SearchBookResultDisplayable) -> Void)
    func pushWriteMemoVC(title: String, completeHandler: @escaping (String) -> Void)
}
