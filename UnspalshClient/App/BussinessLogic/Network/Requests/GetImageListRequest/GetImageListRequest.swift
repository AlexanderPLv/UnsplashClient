//
//  GetImageListRequest.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

protocol GetImageListRequestFactory {
    func get(
        page: Int,
        completion: @escaping (Result<[ImageInfo], Error>) -> Void
    )
}

final class GetImageListRequest {
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

extension GetImageListRequest: AbstractRequestFactory {
    typealias EndPoint = GetImageListResource
    func request(
        withCompletion completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {}
}

extension GetImageListRequest: GetImageListRequestFactory {
    func get(
        page: Int,
        completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {
        let queryItems = [
            URLQueryItem(name: "client_id", value: Access.key),
        URLQueryItem(name: "page", value: "\(page)")
        ]
        let route = GetImageListResource(queryItems: queryItems)
        request(route, withCompletion: completion)
    }
}
