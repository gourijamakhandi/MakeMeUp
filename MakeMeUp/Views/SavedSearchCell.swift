//
//  SavedSearchCell.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 11/26/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit

protocol SavedSearchCellDelegate {
    func getCellData(searchText: String)
}

class SavedSearchCell: UITableViewCell {
    
    var delegate: SavedSearchCellDelegate?
    
    // TODO: connect this to storyboard when ready
    @IBOutlet var savedSearchLabel: UILabel!
    
    func didSelect() {
        delegate?.getCellData(searchText: savedSearchLabel.text ?? "")
    }
}
