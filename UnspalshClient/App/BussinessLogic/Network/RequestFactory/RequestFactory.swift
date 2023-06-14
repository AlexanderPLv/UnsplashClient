//
//  RequestFactory.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

final class RequestFactory {
    
    static let shared = RequestFactory()
    
    private let commonSession: URLSession
    
    private init() {
        self.commonSession = URLSession.shared
    }
}

extension RequestFactory {
    
    func makeImageListRequest() -> GetImageListRequestFactory {
        let serializer = DecodableSerializer<ImageInfo>()
        let encoder = GetRequestEncoder()
        let request = GetImageListRequest(
            sessionManager: commonSession,
            serializer: serializer,
            encoder: encoder
        )
        return request
    }
    
    func makeSearchRequest() -> SearchQueryRequestFactory {
        let serializer = DecodableSerializer<ImageInfo>()
        let encoder = GetRequestEncoder()
        let request = SearchQueryRequest(
            sessionManager: commonSession,
            serializer: serializer,
            encoder: encoder
        )
        return request
    }
}
