//
//  Extension + DateFormatter.swift
//  Extension
//
//  Created by 정다은 on 1/21/25.
//

import Foundation

public extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.locale = Locale(identifier: "ko_KR")
        self.dateFormat = dateFormat
    }
}
