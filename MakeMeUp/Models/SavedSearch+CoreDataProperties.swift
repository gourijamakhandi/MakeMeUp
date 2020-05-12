//
//  SavedSearch+CoreDataProperties.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/26/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSearch> {
        return NSFetchRequest<SavedSearch>(entityName: "SavedSearch")
    }

    @NSManaged public var search_text: String?

}
