//
//  GitHubApi+Strings.swift
//  MyGitHub
//
//  Created by Russell Archer on 13/04/2021.
//

import Foundation

extension GitHubApi {
    
    struct Strings {
        #warning("Define your GitHub Client ID")
        static let clientID = "clientid-goes-here"

        #warning("Define your GitHub Client Secret")
        static let clientSecret = "client-secret-goes-here"
            
        static let httpsScheme                      = "https"
        static let githubHost                       = "github.com"
        static let githubApiHost                    = "api.github.com"
        static let callbackURLScheme                = "mygithub"
        static let httpPostMethodName               = "POST"
        static let httpGetMethodName                = "GET"
        static let accessTokenName                  = "access_token"
        static let refreshTokenName                 = "refresh_token"
        static let authorizationHeaderName          = "Authorization"
        static let accessTokenRequestName           = "token"
        static let accessCodeQueryItemName          = "code"
        static let clientIdQueryItemName            = "client_id"
        static let authenticationScopeName          = "scope"
        static let authenticationScopeValue         = "repo"
        static let clientSecretQueryItemName        = "client_secret"
        static let authenticationCodePath           = "/login/oauth/authorize"
        static let requestTokensPath                = "/login/oauth/access_token"
        static let authenticatedUserPath            = "/user"
        static let userReposPath                    = "/user/repos"
        static let reposVisibilityQueryItemName     = "visibility"
        static let reposVisibilityQueryItemValue    = "all"
        static let reposPerPageQueryItemName        = "per_page"
        static let reposPerPageQueryItemValue       = "100"
        static let reposPageQueryItemName           = "page"
    }
}

