//
//  FilterView.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/14/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit

protocol FilterTagDelegate {
    func filterTagInfo(filterSelected: Bool, filterName: String)
}

class FilterTagCell: UICollectionViewCell {
    
    var filterTagDelegate: FilterTagDelegate?
    
    @IBOutlet weak var filterTagButton: UIButton!
    
    override func awakeFromNib() {
        filterTagButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        filterTagButton.setTitleColor(UIColor.blue, for: UIControl.State.selected)
    }
    
    @IBAction func didTapFilterTagButton(_ sender: Any) {
        filterTagButton.isSelected = !filterTagButton.isSelected
        let filterSelected = filterTagButton.isSelected
        let filterName = filterTagButton.titleLabel?.text ?? ""
        filterTagDelegate?.filterTagInfo(filterSelected: filterSelected, filterName: filterName)
    }
    
}
