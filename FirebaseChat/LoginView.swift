//
//  ContentView.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/21/23.
//

import SwiftUI

struct LoginView: View {
    @State var returningUser = true
    @State var username = ""
    @State var password = ""
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    //Select whether to login or create an account
                    Picker(selection: $returningUser) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker")
                    }.pickerStyle(.segmented)
                        .padding(.horizontal)
                    
                    //Button for profile image?
                    if !returningUser {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 65))
                                .foregroundColor(.purple)
                                .padding()
                        }
                    }
                    
                    //login fields
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .padding(10)
                        .background()
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .padding(10)
                        .background(.white)
                    
                    //login button
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(returningUser ? "Login" : "Create Account")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(10)
                        .background(.purple)
                    }


                }
                .padding()
            }
            .navigationTitle(returningUser ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05)))
            .navigationDestination(isPresented: $userViewModel.userExists) {
                MainMessagesView(chatManager: ChatManager(userViewModel: userViewModel))
            }
        }
    }
    
    private func handleAction() {
        if returningUser {
            print("login with firebase")
            userViewModel.checkLogin(username: username, password: password) { success in
                if success {
                    print("login credentials exist :D")
                } else {
                    print("ooooop. nothing found here. hope that's right!")
                }
            }
        } else {
            print("write new user information to Firebase")
            userViewModel.setNewUser(username: username, password: password, student: false)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}
