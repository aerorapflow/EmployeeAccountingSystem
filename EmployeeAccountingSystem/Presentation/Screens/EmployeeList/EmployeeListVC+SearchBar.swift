//
//  SearchBar.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 31.03.2023.
//

import Foundation
import UIKit
import CoreData

extension EmployeeListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchController.searchBar.text?.isEmpty == true {
            isFiltering = false
            filterContentForSearchText(nil)
            tableView.reloadData()
        } else {
            isFiltering = true
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        filterContentForSearchText(nil)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String?) {
        var predicate: NSPredicate?
        if let searchText = searchText {
            predicate = NSPredicate(format: "firstName CONTAINS[c] %@ OR lastName CONTAINS[c] %@ OR department CONTAINS[c] %@", searchText, searchText, searchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching employees: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

extension EmployeeListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.text?.isEmpty == true {
            isFiltering = false
            filterContentForSearchText(nil)
            tableView.reloadData()
        } else {
            isFiltering = true
            filterContentForSearchText(searchBar.text)
        }
    }
}
