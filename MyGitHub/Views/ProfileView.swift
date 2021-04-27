//
//  ProfileView.swift
//  MyGitHub
//
//  Created by Russell Archer on 18/04/2021.
//

import SwiftUI

struct ProfileView: View {
    @State var user: User
    @Binding var showProfile: Bool
    
    /// Completion handler that will be called when this view closes.
    /// If the value returned is true then the user has indicated they want to sign out.
    var completion: ((Bool) -> Void)? = nil
    
    var body: some View {
        
        // Get all the properties of the currently authenticated GitHub user
        let properties = Array(Mirror(reflecting: user).children)
        var filteredProperties = [String : String]()
        
        // Created a filtered property list, excluding empty values and non-display values
        for property in properties {
            let value = String(describing: property.value)
            if value.isEmpty { continue }
            
            let key = User.propertyDisplayName(propertyName: property.label!)
            if key.isEmpty { continue }  // This is falgged as don't display
            
            filteredProperties[key] = value
        }
        
        return VStack {
            
            ProfileImageView(showProfile: $showProfile, user: user) { requestSignout in
                completion?(requestSignout)  // Pass on a value indicating if the user wants to sign out
            }
            
            ProfileListView(properties: filteredProperties)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileView(user: User(login: "russell-archer",
                               id: 99,
                               nodeId: "999",
                               avatarUrl: "https://avatars.githubusercontent.com/u/6470403?v=4",
                               gravatarId: "",
                               url: "",
                               htmlUrl: "https://github.com/russell-archer",
                               followersUrl: "",
                               followingUrl: "",
                               gistsUrl: "",
                               starredUrl: "",
                               subscriptionsUrl: "",
                               organizationsUrl: "",
                               reposUrl: "",
                               eventsUrl: "",
                               receivedEventsUrl: "",
                               type: "",
                               siteAdmin: false,
                               name: "Russell Archer",
                               company: "RArcher Software Ltd.",
                               blog: "",
                               location: "UK",
                               email: "russell.archer@mac.com",
                               hireable: true,
                               bio: "Developing iOS apps with Swift",
                               twitterUsername: "Russell_Archer",
                               publicRepos: 100,
                               publicGists: 101,
                               followers: 102,
                               following: 103,
                               createdAt: "",
                               updatedAt: ""),
                    showProfile: Binding.constant(true))
    }
}

