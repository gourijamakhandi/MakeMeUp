//
//  MakeupProduct.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/16/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import Foundation
import WebKit

class MakeupProduct {
    
    let id: Int?
    var brand: String?
    var name: String?
    let category: String?
    let product_type: String?
    
    let price: Double?
    let price_sign: String?
    let currency: String?
    let price_text: String?
    
    let image_link: String? // convert to URL later if needed
    let api_featured_image_link: String? // convert to URL later if needed
    let product_link: String? // convert to URL later if needed
    let website_link: String? // convert to URL later if needed
    
    var product_description: String?
    let rating: Int?
    
    let updated_at: String?
    
    var color_names: [String]? = []
    var hex_values: [String]? = []
    let color_count: Int?
    
    var favorited: Bool
    
    var tag_list: [String]? = []
    
    init(dictionary: [String: Any]) {
        
        // CREDIT: https://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift?answertab=votes#tab-top
        // options used for entity reference conversion
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        
        id = dictionary["id"] as? Int ?? -1
        
        let prepareBrand = (dictionary["brand"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        brand = prepareBrand
        if let brandData = prepareBrand.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(data: brandData, options: options, documentAttributes: nil) {
                let convertedString = attributedString.string
                brand = convertedString
            }
        }
        
        
        let prepareName = (dictionary["name"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        name = prepareName
        if let nameData = prepareName.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(data: nameData, options: options, documentAttributes: nil) {
                let convertedString = attributedString.string
                name = convertedString
            }
        }
        
        let prepareCategory = dictionary["category"] as? String ?? ""
        category = prepareCategory.trimmingCharacters(in: .whitespacesAndNewlines)
        product_type = dictionary["product_type"] as? String ?? ""
        
        let price_string = dictionary["price"] as? String ?? "0.0"
        price = Double(price_string)
        price_sign = dictionary["price_sign"] as? String ?? ""
        currency = dictionary["currency"] as? String ?? ""
        if price! > 0.0 {
            let priceFormatted = String(format: "%.02f", price!)
            price_text = price_sign! + priceFormatted
        }
        else { price_text = "Price not available" }
        
        image_link = dictionary["image_link"] as? String ?? ""
        api_featured_image_link = dictionary["api_featured_image_link"] as? String ?? ""
        product_link = dictionary["product_link"] as? String ?? ""
        website_link = dictionary["website_link"] as? String ?? ""
        
        let originalDescription = dictionary["description"] as? String ?? ""
        let removeWhitespaceDescription = (originalDescription.trimmingCharacters(in: .whitespacesAndNewlines))
        var prepareDescription = removeWhitespaceDescription.replacingOccurrences(of: "[\n\t]", with: "", options: .regularExpression, range: nil)
        if prepareDescription == "" { prepareDescription = "No description available" }
        product_description = prepareDescription
        if let descriptionData = prepareDescription.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(data: descriptionData, options: options, documentAttributes: nil) {
                let convertedString = attributedString.string
                product_description = convertedString
            }
        }
        
        rating = dictionary["rating"] as? Int ?? -1
        
        updated_at = dictionary["updated_at"] as? String ?? ""
        
        let product_colors = dictionary["product_colors"] as? [[String: String]] ?? [[:]]
        
        for color in product_colors {
            color_names?.append(color["colour_name"] ?? "")
            hex_values?.append(color["hex_value"] ?? "")
        }
        color_count = color_names?.count
        
        favorited = false
        
        tag_list = dictionary["tag_list"] as? [String] ?? []
 
    }
    
    init(savedMakeupProduct: SavedMakeupProduct) {
        id = savedMakeupProduct.id
        brand = savedMakeupProduct.brand
        name = savedMakeupProduct.name
        category = savedMakeupProduct.category
        product_type = savedMakeupProduct.product_type
        
        price =  savedMakeupProduct.price
        price_sign = savedMakeupProduct.price_sign
        currency = savedMakeupProduct.currency
        price_text = savedMakeupProduct.price_text
        
        image_link = savedMakeupProduct.image_link // convert to URL later if needed
        api_featured_image_link = savedMakeupProduct.api_featured_image_link // convert to URL later if needed
        product_link = savedMakeupProduct.product_link // convert to URL later if needed
        website_link = savedMakeupProduct.website_link // convert to URL later if needed
        
        product_description = savedMakeupProduct.product_description
        rating = savedMakeupProduct.rating
        
        updated_at = savedMakeupProduct.updated_at
        
        color_names = savedMakeupProduct.color_names
        hex_values = savedMakeupProduct.hex_values
        color_count = savedMakeupProduct.color_count
        favorited = savedMakeupProduct.favorited
    }
    
    class func makeupProducts(dictionaries: [[String: Any]]) -> [MakeupProduct] {
        var makeupProducts: [MakeupProduct] = []
        for dictionary in dictionaries {
            let makeupProduct = MakeupProduct(dictionary: dictionary)
            makeupProducts.append(makeupProduct)
        }
        return makeupProducts
    }
    
}
