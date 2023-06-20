//
//  ImageInfo.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation

struct ImageInfo: Codable {
    let id: String
    let createdAt: String
    let description: String?
    var likes: Int
    let urls: Urls
    let user: User
    
    var shortDate: String {
        let subtring = createdAt.prefix { $0 != "T" }
        return String(subtring)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case createdAt = "created_at"
        case likes
        case description
    }
    
    init(id: String, urls: Urls, description: String, user: User, createdAt: String, likes: Int) {
        self.id = id
        self.urls = urls
        self.user = user
        self.createdAt = createdAt
        self.likes = likes
        self.description = description
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
        self.description = image.desc
    }
}
