//
//  ContentViewModel.swift
//  MyGitHub
//
//  Created by Russell Archer on 14/04/2021.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var busy = false
    @Published var authenticated = false
    @Published var repos: [Repository] = []
    @Published var profile: User?
    @Published var hasError = false
    
    var apiError: GitHubApi.ApiError? = nil
    
    private var gitHubApi = GitHubApi()
    private var authentication = Authentication()
    
    /// Allow the user to authenticate themselves on GitHub and give this app delegated access.
    func authenticate() {
        
        busy = true
        gitHubApi.authenticate { [unowned self] result in
            
            busy = false
            switch(result) {
                case .failure(let error):
                    hasError = true
                    apiError = error
                    authenticated = false

                case .success(let auth):
                    authentication = auth
                    authenticated = true
                    requestUserProfileAndRepos()  // Get the user's profile and repos
            }
        }
    }
    
    /// Sign out the currently authenticated GitHub user
    func signOut() {
        authentication.signOut()
        authenticated = false
        profile = nil
        repos = []
    }
    
    /// Get the GitHub profile and repos of the currently authenticated user.
    /// If the user has not previously authenticated this operation will fail but will not be
    /// flagged as an error. The opertation may also fail if the cached access token has
    /// expired, in which case the user is prompted to sign in to GitHub.
    func requestUserProfileAndRepos() {
        
        busy = true
        gitHubApi.userProfile(userAuthentication: authentication) { [unowned self] result in
            
            busy = false
            switch(result) {
                case .failure(let error):
                    if error != .userNotAuthenticated { hasError = true }
                    apiError = error
                    authenticated = false
                    
                case .success(let prof):
                    profile = prof
                    authenticated = true
                    requestUserRepos()
            }
        }
    }
    
    func requestUserRepos() {
        
        busy = true
        gitHubApi.repos(userAuthentication: authentication) { [unowned self] result in
            
            busy = false
            switch(result) {
                case .failure(let error):
                    hasError = true
                    apiError = error
                    
                case .success(let repositorys):
                    repos = repositorys
            }
        }
    }
}
