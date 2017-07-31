//
//  CoreDataService.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 29.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit
import CoreData

class DataBaseService: NSObject {
    fileprivate var managedContext: NSManagedObjectContext
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func saveOrUpdate(newsModels: [NewsContent]) {
        DispatchQueue.main.sync {
            for model in newsModels {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
                fetchRequest.predicate = NSPredicate(format: "id = %@", model.id as CVarArg)
                do {
                    var news = try managedContext.fetch(fetchRequest).first
                    if news == nil {
                        let entity = NSEntityDescription.entity(forEntityName: "News",
                                                                in: managedContext)!
                        news = NSManagedObject(entity: entity, insertInto: managedContext)
                    }
                    news?.setValue(model.id, forKey: "id")
                    news?.setValue(model.publicationDate, forKey: "publicationDate")
                    news?.setValue(model.text, forKey: "title")
                } catch let error {
                    print("Could not save. \(error)")
                }
            }
            do {
                try managedContext.save()
            } catch let error {
                print("Could not save. \(error)")
            }
        }
    }
    
    func fetchRequest(date: Date) -> [NSManagedObject] {
        var news = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        fetchRequest.fetchLimit = 10
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "publicationDate < %@", date as CVarArg)
        do {
            news = try managedContext.fetch(fetchRequest)
        } catch let error {
            print("Could not save. \(error)")
        }
        return news
    }
    
    func getNewsIterator() -> NewsIteratorProtocol {
        return NewsIterator(managedContext: managedContext)
    }
}
