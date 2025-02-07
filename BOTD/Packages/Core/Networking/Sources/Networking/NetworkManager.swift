//
//  NetworkManager.swift
//  Networking
//
//  Created by 정다은 on 2/7/25.
//

import Foundation
import Alamofire

public final class NetworkManager {
    nonisolated(unsafe) public static let shared = NetworkManager()
    private let session = Session()
    
    private init() {    }
    
    public func request(request: RequestProtocol) async throws -> Data {
        let response = await session.request(request.url, method: request.method, parameters: request.parameters)
            .validate().serializingString().response
        
        switch response.result {
        case let .success(jsonString):
            let cleanedJsonString = jsonString.replacingOccurrences(of: ";", with: "")
                .replacingOccurrences(of: "\\/", with: "/")
                .replacingOccurrences(of: "&amp", with: "&")
                .replacingOccurrences(of: "\\", with: "")
            guard let cleanedData = cleanedJsonString.data(using: .utf8) else { throw URLError(.cannotDecodeContentData) }
            return cleanedData
        case let .failure(error):
            throw error
        }
    }
}
