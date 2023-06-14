//
//  ModulesFactory.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 13.06.2023.
//

import Foundation

final class ModulesFactory {
    
    static let shared = ModulesFactory()
    
    let networkService = NetworkService.shared
    
    private init() {}
}
