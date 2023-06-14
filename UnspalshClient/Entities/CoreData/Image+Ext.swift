//
//  Image+Ext.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation
import CoreData

extension Image: BaseModel {
    static func getImage(by id: String) -> Image? {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        guard let images = try? viewContext.fetch(request) else {
            return nil
        }
        return images.first
    }
}
