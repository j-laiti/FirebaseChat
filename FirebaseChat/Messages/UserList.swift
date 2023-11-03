//
//  UserList.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/28/23.
//

import SwiftUI

struct UserList: View {
    @EnvironmentObject var userViewModel: UserViewModel
    let selectedNewUser: (User) -> ()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            ForEach(userViewModel.userList) { user in
                Button {
                    selectedNewUser(user)
                    userViewModel.chatUser = user
                    dismiss()
                    userViewModel.presentSwap()
                } label: {
                    Text(user.username)
                }
            }
//            .onAppear {
//                userViewModel.fetchUsersList()
//            }
        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList(selectedNewUser: { user in
            print(user.username)
        })
            .environmentObject(UserViewModel())
    }
}
