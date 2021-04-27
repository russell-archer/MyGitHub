//
//  ContentView.swift
//  MyGitHub
//
//  Created by Russell Archer on 09/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State var showProfile = false
    
    var body: some View {
        
        return VStack {
            
            if viewModel.authenticated, viewModel.profile != nil {
                ProfileAndReposView(viewModel: viewModel, showProfile: $showProfile)
            }
            else {
                
                if viewModel.busy { ProgressView() }
                else { AuthenticateButton(viewModel: viewModel) }
            }
        }
        .onAppear() {

            viewModel.requestUserProfileAndRepos()
        }
        .sheet(isPresented: $showProfile) {
            
            ProfileView(user: viewModel.profile!, showProfile: $showProfile) { requestSignout in
                if requestSignout { viewModel.signOut() }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            
            Alert(title: Text("Error"),
                  message: Text(viewModel.apiError?.description() ?? "Unknown error"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
