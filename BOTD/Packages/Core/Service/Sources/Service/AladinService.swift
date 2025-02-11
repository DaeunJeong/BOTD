//
//  AladinService.swift
//  Service
//
//  Created by 정다은 on 2/7/25.
//

import Foundation
import Entity
import Extension
import Networking

public protocol AladinServiceProtocol {
    func getBooks(searchQuery: String, page: Int) async throws -> [AladinBook]
}

public final class AladinService: AladinServiceProtocol {
    private let baseURL: String = "https://www.aladin.co.kr/ttb/api/"
    private let ttbKey: String = "ttbalal82721614001"
    public init() {    }
    
    public func getBooks(searchQuery: String, page: Int) async throws -> [AladinBook] {
        let request = Request(url: baseURL + "ItemSearch.aspx", method: .get,
                              parameters: ["TTBKey": ttbKey, "Query": searchQuery, "Start": page, "Output": "JS"])
        let responseData = try await NetworkManager.shared.request(request: request)
        guard let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
              let bookJSON = json["item"] as? [[String: Any]] else { return [] }
        let books = try JSONDecoder().decode([AladinBook].self, json: bookJSON)
        return books
    }
}
