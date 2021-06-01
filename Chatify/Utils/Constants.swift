//
//  Constants.swift
//  Chatify
//
//  Created by Abraham Estrada on 5/26/21.
//

import UIKit
import Firebase

let BACKGROUNDCOLOR: UIColor = #colorLiteral(red: 0.06666666667, green: 0.05882352941, blue: 0.1882352941, alpha: 1)
let TINTCOLOR: UIColor = #colorLiteral(red: 0.03137254902, green: 0.768627451, blue: 0.8431372549, alpha: 1)

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
