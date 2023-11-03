//
//  MainMessagesView.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/22/23.
//

import SwiftUI

struct MainMessagesView: View {
    @State var showLogoutOptions = false
    @State var userListPresented = false
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var chatManager: ChatManager
    
    var body: some View {
        NavigationStack {
            VStack {
                
                messageHeader
                messageList
                
            }
        }
        .navigationDestination(isPresented: $userViewModel.presentUserMessages) {
            ChatView(chatManager: ChatManager(userViewModel: userViewModel))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var messageHeader: some View {
        HStack {
            Image(systemName: "person.circle")
            // call the user information
            Text("Hi \(userViewModel.currentUser?.username ?? "")")
                .bold()
            Spacer()
            
            Button {
                showLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
            }
        }
        .padding()
        .confirmationDialog("Logout", isPresented: $showLogoutOptions) {
            Button("Logout", role: .destructive) {
                userViewModel.logout()
            }
            Button("Cancel", role: .cancel) {
                showLogoutOptions = false
            }
        }
    }
    
    var messageList: some View {
        ScrollView {

            ForEach(chatManager.recentMessages) {message in
                Button {
                    //saves the chat user selected
                    userViewModel.getUserByID(id: message.id) { user in
                        //sets the chat user in the viewmodel
                        userViewModel.chatUser = user
                        
                        //calls the chatview by toggling the bool
                        userViewModel.presentSwap()
                    }
                    
                } label: {
                    HStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 30))
                        
                        VStack(alignment: .leading) {
                            Text(message.name)
                            Text(message.message)
                        }
                        
                        Spacer()
                        
                        Text(message.timeAgo)
                        
                    }.padding(.horizontal)
                    
                    Divider()

                }
            }
        }.overlay(alignment: .bottom) {
            newMessage
        }
        .onAppear {
            userViewModel.fetchUsersList()
        }
    }
    
    var newMessage: some View {
        Button {
            userListPresented = true
        } label: {
            NavButton(title: "+ New Message")
        }
        .sheet(isPresented: $userListPresented) {
            UserList(selectedNewUser: {user in
                print(user.username)
            })
        }
    }
}



struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView(chatManager: ChatManager(userViewModel: UserViewModel()))
            .environmentObject(UserViewModel(isPreview: true))
    }
}
