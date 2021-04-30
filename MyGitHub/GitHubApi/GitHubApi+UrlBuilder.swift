//
//  GitHubApi+UrlBuilder.swift
//  MyGitHub
//
//  Created by Russell Archer on 13/04/2021.
//

import Foundation

extension GitHubApi {
    
    enum AdditionalAuthenticationScope { case none, privateRepos }
    
    /// Build the URL required to start the GitHub authentication process.
    /// * https://docs.github.com/en/developers/apps/authorizing-oauth-apps
    /// * https://docs.github.com/en/developers/apps/scopes-for-oauth-apps
    /// - Parameter scope: Request aditional scope when authenticating. For example, `.privateRepos`
    /// requests that the user grant access to private repos. The default is .none. The user will
    /// be able to approve or reject the requested permission scope when they authenticate.
    /// - Returns: Returns the required URL, or nil if the URL couldn't be constructed.
    func buildRequestAuthenticationCodeUrl(scope: AdditionalAuthenticationScope = .none) -> URL? {
        // Example: https://github.com/login/oauth/authorize?client_id=xxxxx&scope=repo
        
        var query = [URLQueryItem(name: GitHubApi.Strings.clientIdQueryItemName, value: GitHubApi.Strings.clientID)]
        if scope == .privateRepos { query.append(URLQueryItem(name: GitHubApi.Strings.authenticationScopeName, value: GitHubApi.Strings.authenticationScopeValue)) }
        
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubHost
        components.path = GitHubApi.Strings.authenticationCodePath
        components.queryItems = query

        return components.url
    }
    
    /// Build the URL required to complete the GitHub authentication process.
    /// - Parameter authenticationCode: The authentication code provided by GitHub.
    /// - Returns: Returns the required URL, or nil if the URL couldn't be constructed.
    func buildRequestTokensUrl(authenticationCode: String) -> URL? {
        // Example: https://github.com/login/oauth/access_token?client_id=xxxxx&client_secret=xxxxx&code=xxxxx
        
        let query = [URLQueryItem(name: GitHubApi.Strings.clientIdQueryItemName, value: GitHubApi.Strings.clientID),
                     URLQueryItem(name: GitHubApi.Strings.clientSecretQueryItemName, value: GitHubApi.Strings.clientSecret),
                     URLQueryItem(name: GitHubApi.Strings.accessCodeQueryItemName, value: authenticationCode)]
        
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubHost
        components.path = GitHubApi.Strings.requestTokensPath
        components.queryItems = query

        return components.url
    }
    
    /// Build the URL required to request the authenticated user's GitHub profile.
    /// - Returns: Returns the required URL, or nil if the URL couldn't be constructed.
    func buildRequestUserProfileUrl() -> URL? {
        // Example: https://api.github.com/user
        
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubApiHost
        components.path = GitHubApi.Strings.authenticatedUserPath
        components.queryItems = nil

        return components.url
    }
    
    /// Build the URL required to request the authenticated user's repos. Note that by default this will be
    /// limited to all public repos. The user can authorize access to private repos when they authenticate
    /// if the additional `.privateRepos` scope is requested. See `buildRequestAuthenticationCodeUrl(scope:)`.
    /// - Parameter page: The page of repo data requested.
    /// - Returns: Returns the required URL, or nil if the URL couldn't be constructed.
    func buildRequestReposUrl(page: Int) -> URL? {
        // Example: https://api.github.com/user/repos?visibility=all&per_page=100&page=1
        
        let query = [URLQueryItem(name: GitHubApi.Strings.reposVisibilityQueryItemName, value: GitHubApi.Strings.reposVisibilityQueryItemValue),
                     URLQueryItem(name: GitHubApi.Strings.reposPerPageQueryItemName, value: GitHubApi.Strings.reposPerPageQueryItemValue),
                     URLQueryItem(name: GitHubApi.Strings.reposPageQueryItemName, value: String(page))]
        
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubApiHost
        components.path = GitHubApi.Strings.userReposPath
        components.queryItems = query
        
        return components.url
    }
}
