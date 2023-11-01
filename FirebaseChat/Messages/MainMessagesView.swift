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
    
    var body: some View {
        NavigationStack {
            VStack {
                
                messageHeader
                messageList
                
            }
        }
        .navigationDestination(isPresented: $userViewModel.presentUserList) {
            ChatView(chatManager: ChatManager(userViewModel: userViewModel))
        }
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
            ForEach(0...12, id: \.self) {profile in
                HStack(spacing: 20) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                    
                    VStack(alignment: .leading) {
                        Text("username")
                        Text("last message")
                    }
                    
                    Spacer()
                    
                    Text("10m")
                    
                }.padding(.horizontal)
                
                Divider()
            }
        }.overlay(alignment: .bottom) {
            newMessage
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
        MainMessagesView()
            .environmentObject(UserViewModel(isPreview: true))
    }
}
