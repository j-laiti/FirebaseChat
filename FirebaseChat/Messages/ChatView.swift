//
//  ChatView.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/29/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var chatManager: ChatManager
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "person.circle")
                Text("\(userViewModel.chatUser?.username ?? "")")
            }.bold()
            
            ScrollViewReader {proxy in
                ScrollView {
                    ForEach(chatManager.messages) {message in
                        if message.currentUserID == userViewModel.currentUser?.id {
                            HStack {
                                Text(message.text)
                                    .padding()
                                    .background(Color(.purple))
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .trailing)
                        } else {
                            HStack {
                                Text(message.text)
                                    .padding()
                                    .background(Color(.blue))
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .leading)
                        }
                    }
                }
                .onChange(of: chatManager.lastMessageID) { id in
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
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
