//
//  Message.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import Firebase

struct Conversation {
    var user: User
    var recentMessage: Message
}

struct Message {
    let text: String
    let timeStamp: Timestamp
    let sender: String
    let reciever: String
    var user: User?
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.reciever = dictionary["reciever"] as? String ?? ""
        self.sender = dictionary["sender"] as? String ?? ""
        self.timeStamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = sender == Auth.auth().currentUser?.uid
    }
}
