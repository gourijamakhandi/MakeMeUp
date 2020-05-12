//
//  SavedMakeupProduct+CoreDataClass.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/10/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SavedMakeupProduct)
public class SavedMakeupProduct: NSManagedObject {
    
    // call this method to set properties when creating+adding a favorite
    func setProperties(makeupProduct: MakeupProduct) {
        if makeupProduct.id != nil { id = makeupProduct.id ?? -1 }
        if makeupProduct.brand != nil { brand = makeupProduct.brand }
        if makeupProduct.name != nil { name = makeupProduct.name }
        if makeupProduct.category != nil { category = makeupProduct.category }
        if makeupProduct.product_type != nil { product_type = makeupProduct.product_type }
        
        if makeupProduct.price != nil { price =  makeupProduct.price! }
        if makeupProduct.price_sign != nil { price_sign = makeupProduct.price_sign }
        if makeupProduct.currency != nil { currency = makeupProduct.currency }
        if makeupProduct.price_text != nil { price_text = makeupProduct.price_text }
        
        if makeupProduct.image_link != nil { image_link = makeupProduct.image_link } // convert to URL later if needed
        if makeupProduct.api_featured_image_link != nil { api_featured_image_link = makeupProduct.api_featured_image_link } // convert to URL later if needed
        if makeupProduct.product_link != nil { product_link = makeupProduct.product_link } // convert to URL later if needed
        if makeupProduct.website_link != nil { website_link = makeupProduct.website_link } // convert to URL later if needed
        
        if makeupProduct.product_description != nil { product_description = makeupProduct.product_description }
        if makeupProduct.rating != nil { rating = makeupProduct.rating ?? -1 }
        
        if makeupProduct.updated_at != nil { updated_at = makeupProduct.updated_at }
        
        if makeupProduct.color_names != nil { color_names = makeupProduct.color_names }
        if makeupProduct.hex_values != nil { hex_values = makeupProduct.hex_values }
        if makeupProduct.color_count != nil { color_count = makeupProduct.color_count ?? 0 }
        favorited = makeupProduct.favorited
        if makeupProduct.tag_list != nil { tag_list = makeupProduct.tag_list ?? [] }
    }
    
    static func filterSavedMakeupProducts(searchString: String, savedMakeupProducts: [SavedMakeupProduct]) -> [SavedMakeupProduct] {
        var newSavedMakeupProducts: [SavedMakeupProduct] = []
        for product in savedMakeupProducts {
            // create a string comprised of MakeupProduct properties
            var makeupString = product.brand ?? "" + " "
            makeupString.append(contentsOf: product.category ?? "")
            makeupString.append(" ")
            makeupString.append(contentsOf: product.product_description ?? "")
            makeupString.append(" ")
            makeupString.append(contentsOf: product.name ?? "")
            let lowerMakeupString = makeupString.lowercased()
            
            // put searchString words into array
            let searchWords = searchString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            
            // if match at least one word in the string, append
            for searchWord in searchWords {
                let lowerSearchWord = searchWord.lowercased()
                if lowerMakeupString.contains(lowerSearchWord) {
                    newSavedMakeupProducts.append(product)
                    break
                }
            } // end string match loop
        } // end newMakeupProducts loop
        return newSavedMakeupProducts
    }
    
    static func filterSavedMakeupProducts(searchTags: [String], savedMakeupProducts: [SavedMakeupProduct]) -> [SavedMakeupProduct] {
        var newSavedMakeupProducts: [SavedMakeupProduct] = []
        
        for product in savedMakeupProducts {
            var numberToMatch = searchTags.count
            for searchTag in searchTags {
                for productTag in product.tag_list ?? [] {
                    if searchTag.lowercased() == productTag.lowercased() {
                        numberToMatch -= 1
                        break
                    }
                } // end product tag iteration
                
                // if all tags are matched, append to list
                if numberToMatch == 0 {
                    newSavedMakeupProducts.append(product)
                    break
                }
            } // end search tag iteration
        } // end newMakeupProducts loop
        return newSavedMakeupProducts
    }

}
