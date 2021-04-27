//
//  ProfileImageView.swift
//  MyGitHub
//
//  Created by Russell Archer on 22/04/2021.
//

import SwiftUI

struct ProfileImageView: View {
    
    @Binding var showProfile: Bool
    var user: User
    
    /// Completion handler that will be called when this view closes.
    /// If the value returned is true then the user has indicated they want to sign out.
    var completion: ((Bool) -> Void)? = nil
    
    var body: some View {
        
        var avatar = ImageLoader.load(url: user.avatarUrl)
        if avatar == nil { avatar = UIImage(systemName: "person.crop.circle.badge.exclamationmark") }
        
        return VStack {
            HStack {
                Button("Done") { showProfile = false }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                
                Spacer()
                
                Button("Sign out") {
                    showProfile = false
                    completion?(true)  // Tell our parent view that the user wants to sign out
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
            }
            
            Link(destination: URL(string: user.htmlUrl)!) {
                VStack {
                    Image(uiImage: avatar!)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(25)
                        .padding()
                    
                    Text(user.name).font(.title).foregroundColor(.gray).fontWeight(.bold)
                    Text("(\(user.login))").font(.title3).foregroundColor(.gray)
                }
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ProfileImageView(showProfile: Binding.constant(true),
                         user: User(login: "russell-archer",
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
                                    updatedAt: ""))
    }
}
