//
//  SearchQueryRequest.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

protocol SearchQueryRequestFactory {
    func get(
        query: String,
        completion: @escaping (Result<[ImageInfo], Error>) -> Void
    )
}

final class SearchQueryRequest {
    let sessionManager: URLSession
    var serializer: DecodableSerializer<EndPoint.ModelType>
    let encoder: ParameterEncoder
    init(
        sessionManager: URLSession,
        serializer: DecodableSerializer<EndPoint.ModelType>,
        encoder: ParameterEncoder
    ) {
        self.sessionManager = sessionManager
        self.serializer = serializer
        self.encoder = encoder
    }
}

extension SearchQueryRequest: AbstractRequestFactory {
    typealias EndPoint = GetImageListResource
    func request(
        withCompletion completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {}
}

extension SearchQueryRequest: SearchQueryRequestFactory {
    func get(
        query: String,
        completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {
        let queryItems = [
            URLQueryItem(name: "client_id", value: Access.key),
            URLQueryItem(name: "query", value: "\(query)")
        ]
        let route = GetImageListResource(queryItems: queryItems)
        request(route, withCompletion: completion)
    }
}
