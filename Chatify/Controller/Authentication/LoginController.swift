//
//  LoginController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let chatifyLabel: UILabel = {
        let label = UILabel()
        label.text = "Chatify"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.textContentType = .password
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = TINTCOLOR
        button.layer.cornerRadius = 12
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleSignupTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        configureUI()
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser != nil {
            let controller = HomeViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBar.barTintColor = BACKGROUNDCOLOR
            nav.navigationBar.tintColor = TINTCOLOR
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func handleLoginTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showMessage(withTitle: "Failed to Login User", message: "\(error.localizedDescription)")
                return
            }
            self.checkIfUserIsLoggedIn()
        }
    }
    
    @objc func handleSignupTapped() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = BACKGROUNDCOLOR
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(chatifyLabel)
        chatifyLabel.centerX(inView: view)
        chatifyLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 96)
        
        view.addSubview(emailTextField)
        emailTextField.centerX(inView: view)
        emailTextField.anchor(top: chatifyLabel.bottomAnchor, paddingTop: 64)
        emailTextField.setWidth(view.frame.width - 100)
        
        view.addSubview(passwordTextField)
        passwordTextField.centerX(inView: view)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, paddingTop: 24)
        passwordTextField.setWidth(view.frame.width - 100)
        
        view.addSubview(loginButton)
        loginButton.centerX(inView: view)
        loginButton.anchor(top: passwordTextField.bottomAnchor, paddingTop: 64)
        loginButton.setWidth(view.frame.width - 200)
        
        view.addSubview(signupButton)
        signupButton.centerX(inView: view)
        signupButton.anchor(top: loginButton.bottomAnchor, paddingTop: 12)
        signupButton.setWidth(view.frame.width - 150)
    }
}
