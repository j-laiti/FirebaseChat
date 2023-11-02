//
//  Message.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/30/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var currentUserID: String
    var recieverID: String
    var text: String
    var timestamp: Date
}
