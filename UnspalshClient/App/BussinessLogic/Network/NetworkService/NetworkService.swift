//
//  NetworkService.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private let requestFactory: RequestFactory
    
    private init(requestFactory: RequestFactory = RequestFactory.shared) {
        self.requestFactory = requestFactory
    }
    
    func getImageList(
        page: Int,
        completion: @escaping (Result<[ImageInfo], Error>) -> Void
    ) {
        let request = requestFactory.makeImageListRequest()
        request.get(page: page, completion: completion)
    }
    
    func search(
        query: String,
        completion: @escaping (Result<[ImageInfo], Error>) -> Void
    ) {
        let request = requestFactory.makeSearchRequest()
        request.get(query: query, completion: completion)
    }
}
