//
//  HomeViewController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import UIKit
import Firebase

private let cellIdentifier = "cell"

class HomeViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User? {
        didSet{self.fetchConverations()}
    }
    
    private var conversations = [Conversation]()
    private var filteredConversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private lazy var newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = TINTCOLOR
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellIdentifier)
        configureUI()
        configureSearchController()
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newMessageButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        newMessageButton.isHidden = true
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func fetchConverations() {
        guard let user = user else {return}
        MessageService.fetchConversations(for: user) { conversations in
            conversations.forEach { conversation in
                self.conversationsDictionary[conversation.user.uid] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func handleNewMessage() {
        let controller = NewMessageController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleProfileTapped() {
        let controller = ProfileViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Chatify"
        view.backgroundColor = BACKGROUNDCOLOR
        
        tableView.rowHeight = 80
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(handleProfileTapped))
        
        navigationController?.view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 60, width: 60)
        newMessageButton.anchor(bottom: navigationController?.view.bottomAnchor, right: navigationController?.view.rightAnchor, paddingBottom: 32, paddingRight: 32)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search conversations"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = TINTCOLOR
        searchController.searchBar.searchTextField.backgroundColor = UIColor(white: 1, alpha: 0.75)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredConversations.count : conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = inSearchMode ? filteredConversations[indexPath.row] : conversations[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.user = inSearchMode ? filteredConversations[indexPath.row].user : conversations[indexPath.row].user
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
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

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredConversations = conversations.filter{$0.user.fullname.contains(searchText) || $0.user.fullname.lowercased().contains(searchText) || $0.user.username.contains(searchText) || $0.user.username.lowercased().contains(searchText)}
        self.tableView.reloadData()
    }
}
