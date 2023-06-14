//
//  GetRequestEncoder.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

struct GetRequestEncoder: ParameterEncoder {
    public func encode(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws {
        urlRequest.setValue(
            RequestContentType.urlEncoded,
            forHTTPHeaderField: HTTPHeaderFields.contentType
        )
    }
}
