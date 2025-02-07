//
//  Request.swift
//  Networking
//
//  Created by 정다은 on 2/7/25.
//

import Foundation
import Alamofire

public protocol RequestProtocol {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

public class Request: RequestProtocol {
    public let url: String
    public let method: HTTPMethod
    public let parameters: Parameters?
    
    public init(url: String, method: HTTPMethod, parameters: Parameters?) {
        self.url = url
        self.method = method
        self.parameters = parameters
    }
}
