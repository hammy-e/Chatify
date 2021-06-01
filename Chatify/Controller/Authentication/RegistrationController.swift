//
//  RegistrationController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var profileImage: UIImage?
    
    private let profilePictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    
    private let usernameTextField: UITextField = CustomTextField(placeholder: "Username")
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = TINTCOLOR
        button.layer.cornerRadius = 12
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleSignupTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        configureUI()
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
    
    @objc func handleSignupTapped() {
        guard let profileImage = profileImage, let email = emailTextField.text, let password = passwordTextField.text, let fullname = fullnameTextField.text, let username = usernameTextField.text?.lowercased()
        else {
            showMessage(withTitle: "", message: "Please fill in all fields.")
            return
        }
        
        if email.count > 1 && password.count > 1 && fullname.count > 1 && username.count > 1 {
            let credentiels = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
            AuthService.registerUser(withCredentials: credentiels) { error in
                if let error = error {
                    self.showMessage(withTitle: "Failed to Register User", message: "\(error.localizedDescription)")
                    return
                }
                self.checkIfUserIsLoggedIn()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showMessage(withTitle: "", message: "Please fill in all fields.")
        }
    }
    
    @objc func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = BACKGROUNDCOLOR
        
        view.addSubview(profilePictureButton)
        profilePictureButton.centerX(inView: view)
        profilePictureButton.setDimensions(height: 140, width: 140)
        profilePictureButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: profilePictureButton.bottomAnchor, paddingTop: 32)
        stack.setWidth(view.frame.width - 100)
        
        view.addSubview(registerButton)
        registerButton.centerX(inView: view)
        registerButton.anchor(top: stack.bottomAnchor, paddingTop: 32)
        registerButton.setWidth(view.frame.width - 200)
        
        view.addSubview(backButton)
        backButton.centerX(inView: view)
        backButton.anchor(top: registerButton.bottomAnchor, paddingTop: 12)
        backButton.setWidth(view.frame.width - 150)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        profileImage = selectedImage
        
        profilePictureButton.layer.cornerRadius = profilePictureButton.frame.width/2
        profilePictureButton.layer.masksToBounds = true
        profilePictureButton.layer.borderColor = TINTCOLOR.cgColor
        profilePictureButton.layer.borderWidth = 2.5
        profilePictureButton.setImage((selectedImage.withRenderingMode(.alwaysOriginal)), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
