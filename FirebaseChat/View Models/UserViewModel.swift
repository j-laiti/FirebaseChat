//
//  UserViewModel.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/21/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    //published list of users for login to check
    @Published private(set) var userList = [User]()
    @Published private(set) var currentUser: User? //saves the current user's information
    @Published var chatUser: User? //user that the current user is texting
    @Published var userExists = false
    @Published var presentUserList = false
    
    let db = Firestore.firestore()
    
    // Initialize with default values for preview
    convenience init(isPreview: Bool = false) {
        self.init()
        
        if isPreview {
            // Set default values for preview
            self.currentUser = User(id: "previewID", username: "PreviewUser", password: "PreviewPassword", student: true)
            self.chatUser = User(id: "previewID2", username: "PreviewChatUser", password: "PreviewPassword2", student: true)
        }
    }
    
    //function to check existing users and passwords
    func checkLogin(username: String, password: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .whereField("password", isEqualTo: password)
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(false)
                } else {
                    if let document = querySnapshot?.documents.first {
                        let user = try? document.data(as: User.self)
                        self.currentUser = user
                        if let currentUser = self.currentUser {
                            print("current user saved \(currentUser) :P")
                            self.userExists = true
                        } else {
                            print("current user is nilllll")
                        }
                        completion(true)
                    } else {
                        print("User not found")
                        self.currentUser = nil
                        completion(false)
                    }
                }
            }
    }
    
    //function to write additional users to the database
    func setNewUser(username: String, password: String, student: Bool) {
        do {
            let newUser = User(id: "\(UUID())", username: username, password: password, student: student)
            
            try db.collection("users").document().setData(from: newUser)
            
            self.userExists = true
        } catch {
            print("error adding message to Firestore: \(error)")
        }
    }
    
    func fetchUsersList() {
        db.collection("users").getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error getting documents: \(error)")
                return
            } else {
                // Clear the existing user list
                self.userList.removeAll()

                // Iterate through the documents and decode them into User objects
                for document in querySnapshot!.documents {
                    if let user = try? document.data(as: User.self) {
                        self.userList.append(user)
                    }
                }

                // Notify observers that the user list has been updated
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    func presentSwap() {
        presentUserList.toggle()
    }
    
    func logout() {
        chatUser = nil
        currentUser = nil
        self.userExists = false
    }
    
}
