//
//  FirebaseChatApp.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/21/23.
//

import SwiftUI
import Firebase

@main
struct FirebaseChatApp: App {
    @StateObject var userViewModel = UserViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(UserViewModel())
        }
    }
}
