//
//  ConversationCell.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import UIKit
import SDWebImage

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var conversation: Conversation? {
        didSet{configure()}
    }
    
    private let roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = TINTCOLOR
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = BACKGROUNDCOLOR
        
        addSubview(roundedView)
        roundedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 4, paddingRight: 10)
        
        addSubview(profileImage)
        profileImage.setDimensions(height: 48, width: 48)
        profileImage.layer.cornerRadius = 48 / 2
        profileImage.centerY(inView: roundedView)
        profileImage.anchor(left: leftAnchor, paddingLeft: 24)
        
        let stack = UIStackView(arrangedSubviews: [userLabel, messageLabel])
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: roundedView)
        stack.anchor(left: profileImage.rightAnchor, right: roundedView.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let conversation = conversation else {return}
        let message = conversation.recentMessage
        userLabel.text = conversation.user.fullname
        messageLabel.text = message.isFromCurrentUser ? "You: \(message.text)" : message.text
        profileImage.sd_setImage(with: URL(string: conversation.user.profilePictureURL), completed: nil)
    }
}
