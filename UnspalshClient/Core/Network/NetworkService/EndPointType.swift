//
//  EndPointType.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

protocol EndPointType {
    associatedtype ModelType: Decodable
    var host: BaseURL { get }
    var path: Path { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndPointType {
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.baseURL
        components.path = path.path
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return url
    }
}

enum BaseURL {
    case unsplash
}

extension BaseURL {
    var baseURL: String {
        switch self {
        case .unsplash:
            return "api.unsplash.com"
        }
    }
}

enum Path {
    case photos
    case search
}

extension Path {
    var path: String {
        switch self {
        case .photos:
            return "/photos"
        case .search:
            return "/search/photos"
        }
    }
}
