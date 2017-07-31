//
//  News+CoreDataProperties.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 29.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: String?
    @NSManaged public var publicationDate: NSDate?
    @NSManaged public var title: String?

}
