//
//  GetSearchQueryResource.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

struct GetSearchQueryResource: EndPointType {
    typealias ModelType = ImageInfo
    var host: BaseURL = .unsplash
    var path: Path = .search
    var httpMethod: HTTPMethod = .get
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem]
}
