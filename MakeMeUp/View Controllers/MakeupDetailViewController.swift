//
//  MakeupDetailViewController.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/29/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit
import Hero

class MakeupDetailViewController: UIViewController {
    
    @IBOutlet weak var makeupProductNameLabel: UILabel!
    @IBOutlet weak var makeupDetailView: MakeupDetailView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var savedMakeupProduct: SavedMakeupProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if savedMakeupProduct != nil {
            makeupDetailView.savedMakeupProduct = savedMakeupProduct
            makeupProductNameLabel.text = savedMakeupProduct!.name!.uppercased()
            if (makeupDetailView.savedMakeupProduct?.favorited)! { favoriteButton.isSelected = true }
            else { favoriteButton.isSelected = false }
        }
        
        favoriteButton.setImage(UIImage(named: "Favorites"), for: UIControl.State.normal) // filename from image assets
        favoriteButton.setImage(UIImage(named: "FavoritesFilled"), for: UIControl.State.selected) // filename from image assets
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.right)
        
    }
    
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.right)
    }
    
    @IBAction func didTapProductPageButton(_ sender: Any) {
        if savedMakeupProduct != nil {
            if let url = NSURL(string: savedMakeupProduct!.product_link!) {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected // switch selected state
        makeupDetailView.savedMakeupProduct?.favorited = !(makeupDetailView.savedMakeupProduct?.favorited)! // switch favorited state
        Persist.saveContext() // save favorite property value
    }

}
