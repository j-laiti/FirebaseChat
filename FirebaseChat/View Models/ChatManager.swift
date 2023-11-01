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
    private var userViewModel: UserViewModel
    var currentUserID: String {
        userViewModel.currentUser?.id ?? ""
    }
    var recieverID: String {
        userViewModel.chatUser?.id ?? ""
    }
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
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
        let messageData = ["id": currentUserID, "toID": recieverID, "text": self.message, "timestamp": Timestamp()] as [String : Any]
        //3.store data in path!
        document.setData(messageData) { error in
            if let error = error {
                print("failed to save message in Firestore: \(error)")
            }
        }
        
        //save for recipient
        let recievedDocument = db.collection("messages")
            .document(recieverID)
            .collection(currentUserID)
            .document()
    
        recievedDocument.setData(messageData) { error in
            if let error = error {
                print("failed to save message in Firestore: \(error)")
            }
        }
        
        //clear message after send
        self.message = ""
    }
    
    func getMessages() {
        //need to add a different route
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
                    return try document.data(as: Message.self)
                } catch {
                    print("error decoding document: \(error)")
                    return nil
                }
            }
            
            self.messages.sort {$0.timestamp < $1.timestamp}
        }
    }
}
