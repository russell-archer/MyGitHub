//
//  ProfileAndReposView.swift
//  MyGitHub
//
//  Created by Russell Archer on 26/04/2021.
//

import SwiftUI

struct ProfileAndReposView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    @Binding var showProfile: Bool
    
    var body: some View {
        
        VStack {
            
            if let profile = viewModel.profile {
                ProfileAvatarView(sAvatarUrl: profile.avatarUrl, name: profile.name)
                    .onTapGesture { showProfile.toggle() }
            }
            
            if viewModel.repos.count > 0 {
                ReposView(repos: viewModel.repos)
            } else {
                Spacer()
            }
        }
    }
}

struct ProfileAndReposView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAndReposView(viewModel: ContentViewModel(), showProfile: Binding.constant(true))
    }
}
