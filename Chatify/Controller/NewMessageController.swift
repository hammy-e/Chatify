//
//  NewMessageController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import UIKit
import Firebase

private let cellIdentifier = "cell"

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    var users = [User]() {
        didSet{self.tableView.reloadData()}
    }
    var filteredUsers = [User]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 80
        view.backgroundColor = BACKGROUNDCOLOR
        self.hideKeyboardOnTap()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.fetchAllUsers { users in
            self.users = users.filter{$0.uid != Auth.auth().currentUser?.uid}
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "New Message"
        view.backgroundColor = BACKGROUNDCOLOR
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search users"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = TINTCOLOR
        searchController.searchBar.searchTextField.backgroundColor = UIColor(white: 1, alpha: 0.75)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension NewMessageController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
}

// MARK: - UISearchResultsUpdating

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredUsers = users.filter{$0.fullname.contains(searchText) || $0.fullname.lowercased().contains(searchText) || $0.username.contains(searchText) || $0.username.lowercased().contains(searchText)}
        self.tableView.reloadData()
    }
}
