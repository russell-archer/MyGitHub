//
//  AuthenticateButton.swift
//  MyGitHub
//
//  Created by Russell Archer on 26/04/2021.
//

import SwiftUI

struct AuthenticateButton: View {
    
    var viewModel: ContentViewModel
    
    var body: some View {
        
        Button(action: {
            viewModel.authenticate()
        }) {
            Text("Sign in on GitHub")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 350, height: 100)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct AuthenticateButton_Previews: PreviewProvider {

    static var previews: some View {
        AuthenticateButton(viewModel: ContentViewModel())
    }
}
