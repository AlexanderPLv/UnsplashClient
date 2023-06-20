//
//  CoreDataManager.swift
//  UnsplashClient
//
//  Created by Alexander Pelevinov on 14.06.2023.
//

import Foundation
import CoreData

protocol ImageDataManager {
    func delete(_ image: Image) throws
    func save(_ imageInfo: ImageInfo) throws
    func getImage(by id: String) -> Image?
    func isImageExist(with id: String) -> Bool
}

class CoreDataManager: ImageDataManager {
    
    private let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataManager()
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "UnspalshModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize Core Data \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createImageFetchedResultController() -> NSFetchedResultsController<Image> {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]

        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func getImage(by id: String) -> Image? {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        guard let images = try? viewContext.fetch(request) else {
            return nil
        }
        return images.first
    }
    
    func isImageExist(with id: String) -> Bool {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func delete(_ image: Image) throws {
        do {
            viewContext.delete(image)
            try viewContext.save()
        } catch let error {
            throw error
        }
    }
    
    func save(_ imageInfo: ImageInfo) throws {
        let image = Image(context: viewContext)
        
        image.id = imageInfo.id
        image.userName = imageInfo.user.name
        image.location = imageInfo.user.location
        image.url = imageInfo.urls.small
        image.likes = Int32(imageInfo.likes)
        image.createdAt = imageInfo.createdAt
        
        do {
            try viewContext.save()
        } catch let error {
            throw error
        }
    }
}
