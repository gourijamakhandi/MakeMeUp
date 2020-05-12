//
//  MakeupAPISampleVC.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/18/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit

// The sample output from this is in the file "SampleOutput".
// NOTE: this code will not run unless connected to a view controller.
class MakeupAPISampleVC: UIViewController {
    
    var makeupProducts: [MakeupProduct] = [] // local collection in vc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This example fetches lipstick products.
        // The MakeupAPI class has a static struct that stores
        //  each product type as a string (as shown in productType:).
        // NOTE: If desired, we can move this to another class/view controller
        //  or instantiate an instance of the struct in the other class/vc.
        self.fetchMakeup(productType: MakeupAPI.makeupProductTypes.Lipstick)
    }
    
    // This method is created to use the API's fetch method.
    func fetchMakeup(productType: String) {
        // makeupProducts from the args contains products from query
        MakeupAPI().fetchMakeupProducts(productType: productType) { (makeupProducts: [MakeupProduct]?, error: Error?) in
            // pass makeupProducts to our local collection
            if let makeupProducts = makeupProducts { self.makeupProducts = makeupProducts }
            else { print("Error: \(error ?? " " as! Error)") }
            self.testPrintColors()
        }
    }
    
    func testPrintColors() {
        // We can access each property normally except colors.
        // There are 3 color-related properties in MakeupProduct:
        // 1) hex_values, 2) color_names, 3) color_count
        // This test prints products with their colors.
        for makeupProduct in self.makeupProducts {
            print(makeupProduct.name!) // product name
            print("--------------------")
            if makeupProduct.color_count! > 0 {
                for i in 0 ... makeupProduct.color_count! - 1 {
                    print(makeupProduct.color_names![i])
                    print(makeupProduct.hex_values![i])
                    print()
                }
            }
            print("####################\n")
        } // end test print
    }

}
