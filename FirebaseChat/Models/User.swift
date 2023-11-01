//
//  User.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/21/23.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var password: String
    var student: Bool
}
