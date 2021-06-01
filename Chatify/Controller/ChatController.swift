//
//  ChatController.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import UIKit
import Firebase

private let cellIdentifier = "cell"

class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var messages = [Message]()
    
    var user: User? {
        didSet{configureUI()}
    }
    
    private lazy var messageInputView: CustomInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CustomInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = BACKGROUNDCOLOR
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(handleProfileTapped))
        self.hideKeyboardOnTap()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get {return messageInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - API
    
    func fetchMessages() {
        guard let user = user else {return}
        MessageService.fetchMessages(for: user) { messages, error in
            guard let messages = messages else {return}
            self.messages = messages
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let user = user else {return}
        navigationItem.title = user.fullname
        collectionView.alwaysBounceVertical = true
        self.hideKeyboardOnTap()
        fetchMessages()
    }
    
    @objc func handleProfileTapped() {
        let controller = ProfileViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ChatController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}

// MARK: - CustomInputAccessoryViewDelegate

extension ChatController: CustomInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToUploadMessage message: String) {
        guard  let user = user else {return}
        MessageService.sendMessage(message, to: user) { error in
            inputView.clearMessageTextView()
        }
    }
}
