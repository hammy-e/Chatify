//
//  UserService.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/28/21.
//

import Foundation
import Firebase

typealias  FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictonary = snapshot?.data() else {return}
            
            let user = User(dictionary: dictonary)
            completion(user)
        }
    }
    
    static func fetchAllUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let data = snapshot?.documents else {return}
            data.forEach { dictionary in
                users.append(User(dictionary: dictionary.data()))
            }
            completion(users)
        }
    }
}
