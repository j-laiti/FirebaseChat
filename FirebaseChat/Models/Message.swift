//
//  Message.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/30/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String //from id
    var toID: String
    var text: String
    var timestamp: Date
}
