//
//  User.swift
//  MyGitHub
//
//  Created by Russell Archer on 12/04/2021.
//

import Foundation

/// Model for GitHub user profile data.
/// When decoding the JSON provided by the GitHub API you should use the convertFromSnakeCase keyDecodingStrategy.
/// ```
/// let decoder = JSONDecoder()
/// decoder.keyDecodingStrategy = .convertFromSnakeCase
/// let profile = try? decoder.decode(User.self, from: json!)
/// ```
///
struct User: Codable {
    
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String
    let blog: String
    let location: String
    let email: String
    let hireable: Bool
    let bio: String
    let twitterUsername: String
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String
    
    /// A name that can be used when displaying a property.
    /// - Returns: The display name for a property. If the name is empty the field should not normally be displayed.
    static func propertyDisplayName(propertyName: String) -> String {
        switch propertyName {
            case "login":               return "Username"
            case "id":                  return ""
            case "nodeId":              return ""
            case "avatarUrl":           return ""
            case "gravatarId":          return ""
            case "url":                 return ""
            case "htmlUrl":             return ""
            case "followersUrl":        return ""
            case "followingUrl":        return ""
            case "gistsUrl":            return ""
            case "starredUrl":          return ""
            case "subscriptionsUrl":    return ""
            case "organizationsUrl":    return ""
            case "reposUrl":            return ""
            case "eventsUrl":           return ""
            case "receivedEventsUrl":   return ""
            case "type":                return "User Type"
            case "siteAdmin":           return ""
            case "name":                return "Name"
            case "company":             return "Company"
            case "blog":                return "Blog"
            case "location":            return "Location"
            case "email":               return "Email"
            case "hireable":            return "Available for Hire?"
            case "bio":                 return "Bio"
            case "twitterUsername":     return "Twitter"
            case "publicRepos":         return "Public Repos"
            case "publicGists":         return "Public Gists"
            case "followers":           return "Followers Count"
            case "following":           return "Following Count"
            case "createdAt":           return ""
            case "updatedAt":           return ""
            default:                    return ""
        }
    }
}

/*
 
 Example data:
 
 "login":               "russell-archer",
 "id":                  xxxxxxxx,
 "node_id":             "xxxxxxx",
 "avatar_url":          "https://avatars.githubusercontent.com/u/6470403?v=4",
 "gravatar_id":         "",
 "url":                 "https://api.github.com/users/russell-archer",
 "html_url":            "https://github.com/russell-archer",
 "followers_url":       "https://api.github.com/users/russell-archer/followers",
 "following_url":       "https://api.github.com/users/russell-archer/following{/other_user}",
 "gists_url":           "https://api.github.com/users/russell-archer/gists{/gist_id}",
 "starred_url":         "https://api.github.com/users/russell-archer/starred{/owner}{/repo}",
 "subscriptions_url":   "https://api.github.com/users/russell-archer/subscriptions",
 "organizations_url":   "https://api.github.com/users/russell-archer/orgs",
 "repos_url":           "https://api.github.com/users/russell-archer/repos",
 "events_url":          "https://api.github.com/users/russell-archer/events{/privacy}",
 "received_events_url": "https://api.github.com/users/russell-archer/received_events",
 "type":                "User",
 "site_admin":          false,
 "name":                "Russell Archer",
 "company":             "RArcher Software Ltd.",
 "blog":                "https://russell-archer.github.io",
 "location":            "London, UK",
 "email":               "russell.archer@mac.com",
 "hireable":            true,
 "bio":                 "Developing iOS apps with Swift",
 "twitter_username":    "Russell_Archer",
 "public_repos":        44,
 "public_gists":        13,
 "followers":           8,
 "following":           8,
 "created_at":          "2014-01-22T10:53:54Z",
 "updated_at":          "2021-04-15T16:08:09Z"
 
 */
