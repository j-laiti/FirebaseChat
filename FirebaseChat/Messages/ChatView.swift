//
//  ChatView.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/29/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var chatManager: ChatManager
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "person.circle")
                Text("\(userViewModel.chatUser?.username ?? "")")
            }.bold()
            
            ScrollView {
                ForEach(chatManager.messages, id: \.id) {message in
                    Text(message.text)
                }
            }
            
            HStack {
                TextField("test", text: $chatManager.message) //eventually change this to a text editor so that it scrolls up and down
                
                Button {
                    chatManager.sendMessage()
                } label: {
                    Image(systemName: "paperplane.circle")
                }
            }
            .padding(.horizontal)

        }
        .onAppear {
            chatManager.getMessages()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatView(chatManager: ((ChatManager(userViewModel: UserViewModel()))))
                .environmentObject(UserViewModel(isPreview: true))
        }
    }
}
