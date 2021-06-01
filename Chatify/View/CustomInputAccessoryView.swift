//
//  CustomInputAccessoryView.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/29/21.
//

import UIKit

protocol  CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToUploadMessage message: String)
}

class CustomInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private let messageTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Send a message..."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.layer.cornerRadius = 12
        tv.textColor = .white
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(TINTCOLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSendTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = BACKGROUNDCOLOR
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageTextView)
        messageTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Actions
    
    @objc func handleSendTapped() {
        delegate?.inputView(self, wantsToUploadMessage: messageTextView.text)
    }
    
    // MARK: - Helpers
    
    func clearMessageTextView() {
        messageTextView.text = nil
        messageTextView.placeholderLabel.isHidden = false
    }
}
