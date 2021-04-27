//
//  Authentication.swift
//  MyGitHub
//
//  Created by Russell Archer on 14/04/2021.
//

import Foundation

class Authentication {
    
    private var _accessToken: String?
    var accessToken: String? {
        get {
            if _accessToken == nil { _accessToken = Storage.accessToken }
            return _accessToken
        }
        
        set {
            _accessToken = newValue
            Storage.accessToken = newValue
        }
    }
    
    private var _refreshToken: String?
    var refreshToken: String? {
        get {
            if _refreshToken == nil { _refreshToken = Storage.refreshToken }
            return _refreshToken
        }
        
        set {
            _refreshToken = newValue
            Storage.refreshToken = newValue
        }
    }
    
    func signOut() {
        accessToken = nil
        refreshToken = nil
    }
}
