//
//  MakeupAPI.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/16/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import Foundation

struct MakeupProductTypes {
    let Blush = "blush"
    let Bronzer = "bronzer"
    let Eyebrow = "eyebrow"
    let Eyeliner = "eyeliner"
    let Eyeshadow = "eyeshadow"
    let Foundation = "foundation"
    let LipLiner = "lip_liner"
    let Lipstick = "lipstick"
    let Mascara = "mascara"
    let NailPolish = "nail_polish"
}

class MakeupAPI {
    
    static let makeupProductTypes = MakeupProductTypes()
    
    var session: URLSession
    let makeupProductTagNames = [
        "Canadian", "CertClean", "Chemical Free", "Dairy Free", "EWG Verified",
        "EcoCert", "Fair Trade", "Gluten Free", "Hypoallergenic", "Natural",
        "No Talc", "Non-GMO", "Organic", "Peanut Free Product", "Sugar Free",
        "USDA Organic", "Vegan", "alcohol free", "cruelty free", "oil free",
        "purpicks", "silicone free", "water free"
    ]
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func fetchMakeupProducts(productType: String, completion: @escaping ([MakeupProduct]?, Error?) -> ()) {
        let prefixUrlString = "https://makeup-api.herokuapp.com/api/v1/products.json?product_type="
        let jsonUrlString = prefixUrlString + productType
        let url = URL(string: jsonUrlString)
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                
                let makeupProducts = MakeupProduct.makeupProducts(dictionaries: dataDictionary)
                
                completion(makeupProducts, nil)
            } else {
                completion(nil, error)
                print("Error serializing json: ", error!)
            }
        }
        task.resume()
    }
    
//    func filterMakeupProducts(using searchString: String, makeupProducts: [MakeupProduct]) -> [MakeupProduct] {
//        var newMakeupProducts: [MakeupProduct] = []
//        for makeupProduct in makeupProducts {
//            // create a string comprised of MakeupProduct properties
//            var makeupString = makeupProduct.brand ?? "" + " "
//            makeupString.append(contentsOf: makeupProduct.category ?? "")
//            makeupString.append(" ")
//            makeupString.append(contentsOf: makeupProduct.product_description ?? "")
//            makeupString.append(" ")
//            makeupString.append(contentsOf: makeupProduct.name ?? "")
//            let lowerMakeupString = makeupString.lowercased()
//
//            // put searchString words into array
//            let searchWords = searchString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//
//            // if match at least one word in the string, append
//            for searchWord in searchWords {
//                let lowerSearchWord = searchWord.lowercased()
//                if lowerMakeupString.contains(lowerSearchWord) {
//                    newMakeupProducts.append(makeupProduct)
//                    break
//                }
//            } // end string match loop
//        } // end newMakeupProducts loop
//        return newMakeupProducts
//    }
    
}
