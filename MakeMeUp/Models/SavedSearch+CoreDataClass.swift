//
//  SavedSearch+CoreDataClass.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/26/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SavedSearch)
public class SavedSearch: NSManagedObject {
    
    func setSearchText(text: String) {
        search_text = text
    }

}
