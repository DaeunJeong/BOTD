//
//  LibraryCoordinatorProtocol.swift
//  Library
//
//  Created by 정다은 on 2/21/25.
//

import UIKit

public protocol LibraryCoordinatorProtocol {
    @MainActor func presentWriteHistoryVC()
    func presentHistoryDetailVC(bookID: String)
}
