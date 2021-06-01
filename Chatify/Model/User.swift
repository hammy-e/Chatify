//
//  User.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let username: String
    let profilePictureURL: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profilePictureURL = dictionary["profilePictureURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
