//
//  GitHubApi+UrlBuilder.swift
//  MyGitHub
//
//  Created by Russell Archer on 13/04/2021.
//

import Foundation

extension GitHubApi {
    
    func buildRequestAuthenticationCodeUrl() -> URL? {
        let query = [URLQueryItem(name: GitHubApi.Strings.clientIdQueryItemName, value: GitHubApi.Strings.clientID)]
        
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubHost
        components.path = GitHubApi.Strings.authenticationCodePath
        components.queryItems = query
        
        return components.url
    }
    
    func buildRequestTokensUrl(authenticationCode: String) -> URL? {
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
    
    func buildRequestUserProfileUrl() -> URL? {
        var components = URLComponents()
        components.scheme = GitHubApi.Strings.httpsScheme
        components.host = GitHubApi.Strings.githubApiHost
        components.path = GitHubApi.Strings.authenticatedUserPath
        components.queryItems = nil
        
        return components.url
    }
    
    func buildRequestReposUrl(page: Int) -> URL? {
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
