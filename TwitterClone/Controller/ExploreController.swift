//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 14/12/22.
//

import UIKit
import SwiftUI

private let reuseIdentifier = "UserCell"

class ExploreContorller: UITableViewController {
    // -MARK: Properties
    private var users = [User]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var filteredUser = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    // -MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUser()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // -MARK: API
    func fetchUser() {
        UserService.shared.fetchUser { users in
            self.users = users
        }
    }
    
    // -MARK: Helper
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

extension ExploreContorller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreContorller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUser = users.filter({$0.username.localizedStandardContains(searchText)})
    }
}

