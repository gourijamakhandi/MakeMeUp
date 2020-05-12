//
//  MakeupDetailView.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/29/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit
import AlamofireImage

class MakeupDetailView: UIView {
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productBrandLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productDescriptionLabel: UILabel!
    
    var savedMakeupProduct: SavedMakeupProduct? {
        willSet(newSavedMakeupProduct) {
            if let url = URL(string: newSavedMakeupProduct!.image_link!) {
                productImageView.af_setImage(withURL: url)
            }
            productBrandLabel.text = newSavedMakeupProduct?.brand
            productNameLabel.text = newSavedMakeupProduct?.name
            productPriceLabel.text = newSavedMakeupProduct?.price_text
            productDescriptionLabel.text = newSavedMakeupProduct?.product_description
        }
    }
    
    override func awakeFromNib() {
        productNameLabel.preferredMaxLayoutWidth = productNameLabel.frame.size.width
        productBrandLabel.preferredMaxLayoutWidth = productNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productNameLabel.preferredMaxLayoutWidth = productNameLabel.frame.size.width
        productBrandLabel.preferredMaxLayoutWidth = productNameLabel.frame.size.width
    }
    
}

