//
//  MessageService.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import Foundation
import Firebase

struct MessageService {
    
    static func sendMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message,
                    "sender": currentUid,
                    "reciever": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
    
    static func fetchConversations(for user: User, completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        
        let query = COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                UserService.fetchUser(withUid: change.document.documentID) { user in
                    let conversation = Conversation(user: user, recentMessage: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchMessages(for user: User, completion: @escaping([Message]?, Error?) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    let message = Message(dictionary: dictionary)
                    messages.append(message)
                    completion(messages, nil)
                }
            })
        }
    }
}
