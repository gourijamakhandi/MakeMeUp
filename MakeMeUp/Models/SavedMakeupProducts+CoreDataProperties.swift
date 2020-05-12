//
//  SavedMakeupProduct+CoreDataProperties.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/10/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedMakeupProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMakeupProduct> {
        return NSFetchRequest<SavedMakeupProduct>(entityName: "SavedMakeupProduct")
    }

    @NSManaged public var api_featured_image_link: String?
    @NSManaged public var brand: String?
    @NSManaged public var category: String?
    @NSManaged public var color_count: Int
    @NSManaged public var color_names: [String]?
    @NSManaged public var currency: String?
    @NSManaged public var favorited: Bool
    @NSManaged public var hex_values: [String]?
    @NSManaged public var id: Int
    @NSManaged public var image_link: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var price_sign: String?
    @NSManaged public var price_text: String?
    @NSManaged public var product_description: String?
    @NSManaged public var product_link: String?
    @NSManaged public var product_type: String?
    @NSManaged public var rating: Int
    @NSManaged public var tag_list: [String]?
    @NSManaged public var updated_at: String?
    @NSManaged public var website_link: String?

}
