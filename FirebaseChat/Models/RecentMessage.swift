//
//  RecentMessage.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 11/2/23.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable, Codable {
    let currentID: String
    let id: String
    let name: String
    let message: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
