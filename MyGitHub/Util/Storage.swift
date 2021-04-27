//
//  Storage.swift
//  MyGitHub
//
//  Created by Russell Archer on 13/04/2021.
//

import Foundation

/// Read and write data from/to UserDefaults
struct Storage {
    
    private enum StorageStateKey: String {
        case accessToken, refreshToken
        
        func key() -> String {
            switch self {
                case .accessToken:  return "accessToken"
                case .refreshToken: return "refreshToken"
            }
        }
    }
    
    static var accessToken: String? {
        get { UserDefaults.standard.string(forKey: StorageStateKey.accessToken.key()) }
        set { UserDefaults.standard.setValue(newValue, forKey: StorageStateKey.accessToken.key()) }
    }
    
    static var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: StorageStateKey.refreshToken.key()) }
        set { UserDefaults.standard.setValue(newValue, forKey: StorageStateKey.refreshToken.key()) }
    }
}
