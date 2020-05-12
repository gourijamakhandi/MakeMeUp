//
//  ViewController.swift
//  MakeMeUp
//
//  Created by Gouri Jamakhandi on 10/29/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//
import UIKit
import Hero

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unhide when feature is ready
        self.cameraButton.isHidden = true
    }
    
    // variables used to prevent using api fetching after first fetch
    var blush_fetched = false
    var bronzer_fetched = false
    var eyebrow_fetched = false
    var eyeliner_fetched = false
    var eyeshadow_fetched = false
    var foundation_fetched = false
    var lip_liner_fetched = false
    var lipstick_fetched = false
    var mascara_fetched = false
    var nail_polish_fetched = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MakeupTableViewController
        
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.left)
        
        if segue.identifier == "EyelinerSegue" {
            vc.queried = blush_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Eyeliner
            // prevent fetch if previously performed on current run of app
            if blush_fetched == false { blush_fetched = true }
        }
        if segue.identifier == "MascaraSegue" {
            vc.queried = mascara_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Mascara
            // prevent fetch if previously performed on current run of app
            if mascara_fetched == false { mascara_fetched = true }
        }
        if segue.identifier == "LipLinerSegue" {
            vc.queried = lip_liner_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.LipLiner
            // prevent fetch if previously performed on current run of app
            if lip_liner_fetched == false { lip_liner_fetched = true }
        }
        if segue.identifier == "LipstickSegue" {
            vc.queried = lipstick_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Lipstick
            // prevent fetch if previously performed on current run of app
            if lipstick_fetched == false { lipstick_fetched = true }
        }
        if segue.identifier == "NailPolishSegue" {
            vc.queried = nail_polish_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.NailPolish
            // prevent fetch if previously performed on current run of app
            if nail_polish_fetched == false { nail_polish_fetched = true }
        }
        if segue.identifier == "BronzerSegue" {
            vc.queried = bronzer_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Bronzer
            // prevent fetch if previously performed on current run of app
            if bronzer_fetched == false { bronzer_fetched = true }
        }
        if segue.identifier == "BlushSegue" {
            vc.queried = blush_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Blush
            // prevent fetch if previously performed on current run of app
            if blush_fetched == false { blush_fetched = true }
        }
        if segue.identifier == "EyeshadowSegue" {
            vc.queried = eyeshadow_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Eyeshadow
            // prevent fetch if previously performed on current run of app
            if eyeshadow_fetched == false { eyeshadow_fetched = true }
        }
        if segue.identifier == "FoundationSegue" {
            vc.queried = foundation_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Foundation
            // prevent fetch if previously performed on current run of app
            if foundation_fetched == false { foundation_fetched = true }
        }
        if segue.identifier == "EyebrowSegue" {
            vc.queried = eyebrow_fetched
            vc.queryName = MakeupAPI.makeupProductTypes.Eyebrow
            // prevent fetch if previously performed on current run of app
            if eyebrow_fetched == false { eyebrow_fetched = true }
        }
        if segue.identifier == "FavoritesSegue" {
            vc.queried = true
            vc.queryName = "favorites" // no api query when fetching favorites
        }
        vc.cameFromHome = true
     }
    
}
