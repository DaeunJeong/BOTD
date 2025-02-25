//
//  EditHistoryCoordinatorProtocol.swift
//  WriteHistory
//
//  Created by 정다은 on 2/25/25.
//

public protocol EditHistoryCoordinatorProtocol {
    func pushWriteMemoVC(title: String, completeHandler: @escaping (String) -> Void)
}
