//
//  ImageInfo.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

struct ImageInfo: Codable {
    let id: String
    let urls: Urls
    let user: User
    let createdAt: String
    var likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case createdAt = "created_at"
        case likes
    }
    
    init(id: String, urls: Urls, user: User, createdAt: String, likes: Int) {
        self.id = id
        self.urls = urls
        self.user = user
        self.createdAt = createdAt
        self.likes = likes
    }
    
    init?(image: Image) {
        guard let id = image.id,
              let url = image.url,
              let name = image.userName,
              let date = image.createdAt
        else { return nil }
        self.id = id
        self.urls = Urls(small: url)
        self.user = User(name: name, location: image.location)
        self.createdAt = date
        self.likes = Int(image.likes)
    }
}
