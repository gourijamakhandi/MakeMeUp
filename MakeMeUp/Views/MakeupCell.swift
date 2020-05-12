//
//  MakeupCell.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/24/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit
import AlamofireImage

class MakeupCell: UITableViewCell {
    
    @IBOutlet weak var makeupProductImageView: UIImageView!
    @IBOutlet weak var makeupProductNameLabel: UILabel!
    @IBOutlet weak var makeupProductBrandLabel: UILabel!
    @IBOutlet weak var makeupProductPriceLabel: UILabel!
    
    var savedMakeupProduct: SavedMakeupProduct? {
        willSet(newSavedMakeupProduct) {
            if let imageURL = URL(string: newSavedMakeupProduct!.image_link!) {
                makeupProductImageView.af_setImage(withURL: imageURL)
            } else {
                
            }
            makeupProductNameLabel.text = newSavedMakeupProduct?.name
            makeupProductBrandLabel.text = newSavedMakeupProduct?.brand
            makeupProductPriceLabel.text = newSavedMakeupProduct?.price_text
        }
    }
    
    override func awakeFromNib() {
        makeupProductNameLabel.preferredMaxLayoutWidth = makeupProductNameLabel.frame.size.width
        makeupProductBrandLabel.preferredMaxLayoutWidth = makeupProductNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeupProductNameLabel.preferredMaxLayoutWidth = makeupProductNameLabel.frame.size.width
        makeupProductBrandLabel.preferredMaxLayoutWidth = makeupProductNameLabel.frame.size.width
    }
    
    override func prepareForReuse() {
        makeupProductImageView.image = nil
        makeupProductNameLabel.text = nil
        makeupProductBrandLabel.text = nil
    }
    
}
