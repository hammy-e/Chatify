//
//  ProfileViewController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/31/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet{configure()}
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2.5
        iv.layer.borderColor = TINTCOLOR.cgColor
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = TINTCOLOR
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = TINTCOLOR
        button.layer.cornerRadius = 12
        button.setDimensions(height: 50, width: view.frame.width - 120)
        button.isHidden = user?.uid != Auth.auth().currentUser?.uid
        button.addTarget(self, action: #selector(handleLogoutTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BACKGROUNDCOLOR
        
        view.addSubview(profileImageView)
        profileImageView.setDimensions(height: 120, width: 120)
        profileImageView.layer.cornerRadius = 60
        profileImageView.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 64)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: profileImageView.bottomAnchor, paddingTop: 24)
        
        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view, topAnchor: stack.bottomAnchor, paddingTop: 24)
    }
    
    // MARK: - API
    
    @objc func handleLogoutTapped() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            showMessage(withTitle: "Error", message: "Failed to sign out")
        }
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let user = user else {return}
        profileImageView.sd_setImage(with: URL(string: user.profilePictureURL), completed: nil)
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@\(user.username)"
    }
}
