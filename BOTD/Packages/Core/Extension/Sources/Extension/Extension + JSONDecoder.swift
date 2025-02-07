//
//  Extension + JSONDecoder.swift
//  Extension
//
//  Created by 정다은 on 2/7/25.
//

import Foundation

extension JSONDecoder {
    public func decode<Item: Decodable>(_ type: Item.Type, json: Any) throws -> Item {
        let data = try JSONSerialization.data(withJSONObject: json)
        return try decode(type, from: data)
    }
}

