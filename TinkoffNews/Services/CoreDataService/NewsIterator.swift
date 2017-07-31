//
//  NewsIterator.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 30.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit
import CoreData

protocol NewsIteratorProtocol {
    func getNext(fetchLimit: Int) -> [NewsContent]
    func isEmpty() -> Bool
}

class NewsIterator: NewsIteratorProtocol {
    private var managedContext: NSManagedObjectContext
    private var nextDate: Date
    
    init(managedContext :NSManagedObjectContext) {
        self.managedContext = managedContext
        nextDate = Date()
    }
    
    func getNext(fetchLimit: Int) -> [NewsContent] {
        return getNext(fetchLimit: fetchLimit).map({ managedObject in
            return self.createNewsContentFrom(news: managedObject)
        })
    }
    
    func isEmpty() -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            let count = try managedContext.count(for: request)
            return count == 0 ? true : false
        } catch let error {
            print("Could not save. \(error)")
        }
        return false
    }
    
    private func getNext(fetchLimit: Int) -> [NSManagedObject] {
        var news = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        fetchRequest.fetchLimit = fetchLimit
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "publicationDate < %@", nextDate as CVarArg)
        do {
            news = try managedContext.fetch(fetchRequest)
            nextDate = news.last?.value(forKey: "publicationDate") as! Date
        } catch let error {
            print("Could not save. \(error)")
        }
        return news
    }
    
    private func createNewsContentFrom(news: NSManagedObject) -> NewsContent {
        return NewsContent(id: news.value(forKey: "id") as! String,
                           text: news.value(forKey: "title") as! String,
                           publicationDate: news.value(forKey: "publicationDate") as! Date, content: "")
    }
}
