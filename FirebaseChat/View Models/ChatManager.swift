//
//  ChatManager.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/29/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatManager: ObservableObject {
    @Published var message = ""
    @Published var messages: [Message] = []
    @Published var recentMessages: [RecentMessage] = []
    var userViewModel: UserViewModel
    var lastMessageID = ""
    var currentUserID: String {
        userViewModel.currentUser?.id ?? ""
    }
    var recieverID: String {
        userViewModel.chatUser?.id ?? ""
    }
    var currentUserName: String {
        userViewModel.currentUser?.username ?? ""
    }
    var recieverUsername: String {
        userViewModel.chatUser?.username ?? ""
    }
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        getMessages()
        fetchRecentMessages()
        print("initialised")
    }
    
    let db = Firestore.firestore()
    
    func sendMessage() {
        print(message)
         
        //save for sender
        //1. define path
        let document = db.collection("messages")
            .document(currentUserID)
            .collection(recieverID)
            .document()
        //2. define data
        let newMessage = ["id": "\(UUID())", "currentUserID": currentUserID, "recieverID": recieverID, "text": message, "timestamp": Date()] as [String: Any]
        //3.store data in path!
        document.setData(newMessage) { error in
            if let error = error {
                print("failed to save message in Firestore: \(error)")
            }
        }
        
        //save for recipient
        let recievedDocument = db.collection("messages")
            .document(recieverID)
            .collection(currentUserID)
            .document()
    
        recievedDocument.setData(newMessage) { error in
            if let error = error {
                print("failed to save message in Firestore: \(error)")
            }
        }
        //save the most recent message in Firestore
        saveLastMessage()
        
        //clear message after send
        self.message = ""
    }
    
    func getMessages() {
        guard !currentUserID.isEmpty, !recieverID.isEmpty else {
                print("CurrentUserID or RecieverID is empty. Cannot fetch messages.")
                return
            }

        db.collection("messages")
            .document(currentUserID)
            .collection(recieverID)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("error fetching document: \(String(describing: error))")
                    return
                }
                
                self.messages = documents.compactMap { document -> Message? in
                    do {
                        print("trying to save as a Message")
                        return try document.data(as: Message.self)
                    } catch {
                        print("error decoding document: \(error)")
                        return nil
                    }
                }
                
                //order messages by time
                self.messages.sort {$0.timestamp < $1.timestamp}
                
                //keep track of the most recent message
                if let id = self.messages.last?.id {
                    self.lastMessageID = id
                }
            }
    
    }
    
    private func saveLastMessage() {
        let document = db.collection("recent_messages")
            .document(currentUserID)
            .collection("messages")
            .document(recieverID)
        
        let lastMessage = [
            "timestamp": Timestamp(),
            "message": message,
            "currentID": currentUserID,
            "id": recieverID,
            "name": recieverUsername
        ] as [String : Any]
        
        document.setData(lastMessage) { error in
            if let error = error {
                print("Failed to save recent message \(error)")
                return
            }
        }
        
        //save for the recipient
        let document2 = db.collection("recent_messages")
            .document(recieverID)
            .collection("messages")
            .document(currentUserID)
        //need to change this eventually
        let lastMessage2 = [
            "timestamp": Timestamp(),
            "message": message,
            "id": currentUserID,
            "currentID": recieverID,
            "name": currentUserName
        ] as [String : Any]
        
        document2.setData(lastMessage2) { error in
            if let error = error {
                print("Failed to save recent message \(error)")
                return
            }
        }
    }
    
    func fetchRecentMessages() {
        guard !currentUserID.isEmpty else {
                print("CurrentUserID is empty. Cannot fetch recent messages.")
                return
            }
        
        db.collection("recent_messages")
            .document(currentUserID)
            .collection("messages")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("error fetching recent messages: \(String(describing: error))")
                    return
                }
                
                self.recentMessages = documents.compactMap { document -> RecentMessage? in
                    do {
                        print("trying to save as a Message")
                        return try document.data(as: RecentMessage.self)
                    } catch {
                        print("error decoding document: \(error)")
                        return nil
                    }
                }
                
                //order messages by time
                self.recentMessages.sort {$1.timestamp < $0.timestamp}
            }
    }
}
