//
//  MakeupTableViewController.swift
//  MakeMeUp
//
//  Created by Brian Casipit on 10/24/18.
//  Copyright © 2018 kissmyassembly. All rights reserved.
//

import UIKit
import CoreData
import Hero

// FIXME: methods for fetching makeup products is currently not organized well
// - because of asyncrhronous completion, statements are not being executed in order
// - the easy solution is to call methods at the beginning/end of other methods
// - this is the current solution until another solution is found...
class MakeupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var makeupCategoryLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! // filter collection view
    @IBOutlet weak var filterViewTrailingConstraint: NSLayoutConstraint! // change for animation
    
    @IBOutlet weak var tableView: UITableView! // makeup products
    
    // TODO: conect when ready to use
    @IBOutlet weak var savedSearchView: UIView! // saved searches
    @IBOutlet weak var savedSearchTableView: UITableView!// saved searches
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var makeupProducts: [MakeupProduct] = []
    var savedMakeupProducts: [SavedMakeupProduct] = []
    var unfilteredMakeupProducts: [SavedMakeupProduct] = []
    
    var selectedTags: [String] = []
    var savedSearches: [String] = []
    
    var queryName: String! // from home view controller
    var queried: Bool! // from home view controller
    
    var cameFromHome = true
    var showMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't display extra empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        savedSearchTableView.tableFooterView = UIView(frame: .zero)
        
        // scale up the activity indicator
        let transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        activityIndicatorView.transform = transform
        
        filterViewTrailingConstraint.constant = filterView.frame.width
        
        tableView.dataSource = self
        collectionView.dataSource = self
        savedSearchTableView.dataSource = self
        
        // TODO: uncomment when ready to connect/use
        savedSearchTableView.delegate = self
        
        savedSearchView.isHidden = true
        
        // set title label at the top of the view controller
        let editQueryName = queryName.replacingOccurrences(of: "_", with: " ")
        makeupCategoryLabel.text = editQueryName.uppercased()
        
        // option A) fetch+update products using api if app restarted
        if !queried && cameFromHome { self.fetchMakeup(productType: queryName) }
        // option B) fetch products from core data if app not restarted
        if queried && cameFromHome { self.fetchSavedMakeup(productType: queryName) }
        // option C) update favorites for favorite query every time view loads
        if queryName == "favorites" { self.fetchSavedMakeup(productType: queryName) }
        
        // TODO: uncomment when ready to connect/use
        self.fetchSavedSearches()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // update favorites table view
        if queryName == "favorites" { self.fetchSavedMakeup(productType: queryName) }
        // deselect cell
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @IBAction func swipeBack(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.right)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.right)
        
    }
    
    // FETCH METHODS //
    // This method uses the API's fetch method.
    func fetchMakeup(productType: String) {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        
        // makeupProducts from the args contains products from query
        MakeupAPI().fetchMakeupProducts(productType: productType) { (makeupProducts: [MakeupProduct]?, error: Error?) in
            // pass makeupProducts to our local collection
            if let makeupProducts = makeupProducts {
                self.makeupProducts = makeupProducts
                
                // FIXME: remove this when fetching problem is solved
                self.fetchSavedMakeup(productType: self.queryName)
            }
            else {
                print("Error: \(error ?? " " as! Error)")
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
    // This method only fetches makeup from coredata.
    func fetchSavedMakeup(productType: String) {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        // load/reload favorites
        let fetchRequest: NSFetchRequest<SavedMakeupProduct> = SavedMakeupProduct.fetchRequest()
        do {
            let savedMakeupProducts = try Persist.context.fetch(fetchRequest)
            // filter results
            var filteredMakeupProducts: [SavedMakeupProduct]
            if queryName == "favorites" { filteredMakeupProducts = savedMakeupProducts.filter{ $0.favorited } }
            else { filteredMakeupProducts = savedMakeupProducts.filter{ $0.product_type == queryName } }
            self.savedMakeupProducts = filteredMakeupProducts
            
            // check for products not already in core data
            for makeup in self.makeupProducts {
                var idEncountered = false
                for savedMakeup in self.savedMakeupProducts {
                    if makeup.id == savedMakeup.id {
                        idEncountered = true
                        break
                    }
                }
                if !idEncountered {
                    let newSavedMakeupProduct = SavedMakeupProduct(context: Persist.context)
                    newSavedMakeupProduct.setProperties(makeupProduct: makeup)
                    Persist.saveContext()
                    self.savedMakeupProducts.append(newSavedMakeupProduct)
                }
            }
            
            // set unfilteredMakeupProducts after savedMakeupProducts are updated
            self.unfilteredMakeupProducts = self.savedMakeupProducts
            
            // update core data if any products were updated
            for savedMakeup in self.savedMakeupProducts {
                for makeup in self.makeupProducts {
                    if savedMakeup.id == makeup.id {
                        if savedMakeup.updated_at != makeup.updated_at {
                            savedMakeup.setProperties(makeupProduct: makeup)
                            Persist.saveContext()
                        }
                        break // avoid full iteration if possible
                    }
                }
            } // end core data update
            self.cameFromHome = false
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            tableView.reloadData()
            
        } catch {
            // do something to catch error
        }
    }
    // This method fetches saved searches from coredata.
    // TODO: uncomment when ready to connect/use
    func fetchSavedSearches() {
        // load/reload favorites
        let fetchRequest: NSFetchRequest<SavedSearch> = SavedSearch.fetchRequest()
        do {
            print("Fetching saved searches...") // TESTPRINT
            let savedSearches = try Persist.context.fetch(fetchRequest)
            for savedSearch in savedSearches {
                self.savedSearches.append(savedSearch.search_text!)
            }
            savedSearchTableView.reloadData()
            print("Saved search table view reloaded!") // TESTPRINT
        } catch {
            // do something to catch error
        }
    }
    
    // SEARCH METHODS//
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.savedSearchView.isHidden = false
        self.savedSearchTableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.savedSearchView.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.combineFilters()
        if self.searchBar.text != nil {
            if !self.savedSearches.contains(self.searchBar.text!) {
                // Create a new SavedSearch object
                let newSavedSearch = SavedSearch(context: Persist.context)
                newSavedSearch.setSearchText(text: self.searchBar.text!)
                
                // Save it to the context
                Persist.saveContext()
                
                // Append it to the SavedSearch array
                self.savedSearches.append(newSavedSearch.search_text!)
                print("Search button was tapped!")
                print(self.savedSearches.count)
                for search in self.savedSearches {
                    print(search)
                }
            }
        }
        
        // Hide search history view
        self.savedSearchView.isHidden = true
        self.searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.combineFilters()
        self.view.endEditing(true)
    }
    
    // FILTER VIEW METHOD //
    @IBAction func didTapFilterButton(_ sender: Any) {
        showMenu = !showMenu
        
        if showMenu { filterViewTrailingConstraint.constant = 0 }
        else { filterViewTrailingConstraint.constant = filterView.frame.width }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { self.view.layoutIfNeeded() })
    }
    
    // COMBINE ALL FILTERING //
    func combineFilters() {
        // apply search bar filters
        if (self.searchBar.text != "") {
            let searchString = self.searchBar.text!.lowercased()
            let filteredMakeupProducts = SavedMakeupProduct.filterSavedMakeupProducts(searchString: searchString, savedMakeupProducts: self.unfilteredMakeupProducts)
            self.savedMakeupProducts = filteredMakeupProducts
        } else {
            self.savedMakeupProducts = self.unfilteredMakeupProducts
        }
        
        // apply tag filters
        if !selectedTags.isEmpty {
            let filteredMakeupProducts = SavedMakeupProduct.filterSavedMakeupProducts(searchTags: selectedTags, savedMakeupProducts: self.savedMakeupProducts)
            self.savedMakeupProducts = filteredMakeupProducts
        }
        
        self.tableView.reloadData()
    }
    
    // COLLECTIONVIEW METHODS FOR TAG FILTERS //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MakeupAPI().makeupProductTagNames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTagCell", for: indexPath) as! FilterTagCell
        let buttonTitle = MakeupAPI().makeupProductTagNames[indexPath.row]
        cell.filterTagButton.setTitle(buttonTitle, for: UIControl.State.normal)
        cell.filterTagButton.setTitle(buttonTitle, for: UIControl.State.selected)
        cell.filterTagDelegate = self
        return cell
    }
    
    // TABLEVIEW METHODS FOR MAKEUP PRODUCTS //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return savedMakeupProducts.count
        }
        if tableView == self.savedSearchTableView { // if tableView == savedSearchTableView
            print("Saved searches count was passed!")
            return savedSearches.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MakeupCell", for: indexPath) as! MakeupCell
            cell.tag = indexPath.row
            cell.savedMakeupProduct = self.savedMakeupProducts[indexPath.row]
            return cell
        }
        // TODO: set id on storyboard when ready
        if tableView == savedSearchTableView { //if tableView == savedSearchTableView
            print("Saved searches were supposedly loaded!")
            let cell = self.savedSearchTableView.dequeueReusableCell(withIdentifier: "SavedSearchCell", for: indexPath) as! SavedSearchCell
            //cell.tag = indexPath.row
            // set cell's label text
            cell.savedSearchLabel.text = self.savedSearches[indexPath.row]
            return cell
        }
        return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    // TABLEVIEW METHODS FOR SAVED SEARCHES //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == savedSearchTableView {
            let cell = tableView.cellForRow(at: indexPath) as! SavedSearchCell
            cell.didSelect()
            self.getCellData(searchText: cell.savedSearchLabel.text!)
        }
    }
    
    // SEGUE PREPARATION //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! MakeupDetailViewController
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.left)
            let cell = sender as! MakeupCell
            if let indexPath = self.tableView.indexPath(for: cell) {
                vc.savedMakeupProduct = savedMakeupProducts[indexPath.row]
            }
        }
    }
    
}

extension MakeupTableViewController: FilterTagDelegate {
    func filterTagInfo(filterSelected: Bool, filterName: String) {
        // if selected filter is "ON", append it to tag list
        if filterSelected {
            if !selectedTags.contains(filterName) {
                selectedTags.append(filterName)
            }
        }
        // if selected filter is "OFF", remove it from tag list
        else {
            if selectedTags.contains(filterName) {
                selectedTags = selectedTags.filter(){ $0 != filterName }
            }
        }
        print("Tags: \(selectedTags)")
        self.combineFilters()
    }
}

extension MakeupTableViewController: SavedSearchCellDelegate {
    func getCellData(searchText: String) {
        // pass searchText to search bar
        self.searchBar.text = searchText
    }
}
