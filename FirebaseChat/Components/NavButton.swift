//
//  NavButton.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 10/28/23.
//

import SwiftUI

struct NavButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .foregroundColor(Color(.white))
            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            .background(.purple.gradient)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct NavButton_Previews: PreviewProvider {
    static var previews: some View {
        NavButton(title: "Login")
    }
}
