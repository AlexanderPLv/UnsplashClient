//
//  ParameterEncoding.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws
}

extension ParameterEncoder {
    func createBoundary() -> String {
        return UUID().uuidString
    }
    
    func lineBreak() -> String {
        return "\r\n"
    }
}


