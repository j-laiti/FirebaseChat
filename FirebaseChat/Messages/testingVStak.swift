//
//  testingVStak.swift
//  FirebaseChat
//
//  Created by Justin Laiti on 11/1/23.
//

import SwiftUI

struct testingVStak: View {
    var body: some View {
        ScrollView {
            HStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color(.purple))
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .leading)
            
            HStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color(.purple))
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 32, alignment: .trailing)
        }
    }
}

struct testingVStak_Previews: PreviewProvider {
    static var previews: some View {
        testingVStak()
    }
}
