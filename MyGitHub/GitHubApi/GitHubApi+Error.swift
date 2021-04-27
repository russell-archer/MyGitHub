//
//  GitHubApi+Error.swift
//  MyGitHub
//
//  Created by Russell Archer on 13/04/2021.
//

import Foundation

extension GitHubApi {
    
    enum ApiError: Error {
        case noError, gitHubError, badAuthenticationCode, cantStartSession, badParams, badResponse, noData, cantDecode, cantGetToken, userNotAuthenticated
        
        func description() -> String {
            switch self {
                case .noError:                  return "No error"
                case .gitHubError:              return "GitHub error"
                case .badAuthenticationCode:    return "GitHub supplied an invalid authentication code"
                case .cantStartSession:         return "Can't start ASWebAuthenticationSession"
                case .badParams:                return "Can't make a valid URL using the supplied parameters"
                case .badResponse:              return "Server returned an error"
                case .noData:                   return "No data returned by GitHub"
                case .cantDecode:               return "Not decodable (JSON couldn't be parsed)"
                case .cantGetToken:             return "Request for access token failed"
                case .userNotAuthenticated:     return "The current user is not authenticated"
            }
        }
    }
}

