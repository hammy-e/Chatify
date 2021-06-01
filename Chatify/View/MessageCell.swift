//
//  MessageCell.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import UIKit
import SDWebImage

class MessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var message: Message? {
        didSet{configure()}
    }
    
    var roundedViewLeftAnchor: NSLayoutConstraint!
    var roundedViewRightAnchor: NSLayoutConstraint!
    
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
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        profileImage.setDimensions(height: 32, width: 32)
        profileImage.layer.cornerRadius = 32 / 2
        profileImage.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 12, paddingBottom: -4)
        
        addSubview(roundedView)
        roundedView.anchor(top: topAnchor, bottom: bottomAnchor)
        roundedView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        roundedViewLeftAnchor = roundedView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12)
        roundedViewLeftAnchor.isActive = false
        roundedViewRightAnchor = roundedView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        roundedViewRightAnchor.isActive = false
        
        
        addSubview(textView)
        textView.anchor(top: roundedView.topAnchor, left: roundedView.leftAnchor, bottom: roundedView.bottomAnchor, right: roundedView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let message = message else {return}
        textView.text = message.text
        textView.textColor = message.isFromCurrentUser ? .black : .white
        
        roundedView.backgroundColor = message.isFromCurrentUser ? TINTCOLOR : UIColor(white: 1, alpha: 0.1)
        
        profileImage.sd_setImage(with: URL(string: message.user?.profilePictureURL ?? ""), completed: nil)
        profileImage.isHidden = message.isFromCurrentUser
        
        roundedViewLeftAnchor.isActive = !message.isFromCurrentUser
        roundedViewRightAnchor.isActive = message.isFromCurrentUser
    }
}
