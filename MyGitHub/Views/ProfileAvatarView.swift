//
//  ProfileAvatarView.swift
//  MyGitHub
//
//  Created by Russell Archer on 22/04/2021.
//

import SwiftUI

struct ProfileAvatarView: View {
    
    var sAvatarUrl: String
    var name: String
    
    var body: some View {
        
        VStack {
            HStack {
                Text(name)
                    .font(.title)
                    .padding()
                
                Spacer()
                
                if let image = ImageLoader.load(url: sAvatarUrl) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(Color(.white))
                        .clipShape(Circle())
                        .padding(.trailing, 15)
                } else {
                    
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(Color(.white))
                        .foregroundColor(.red)
                        .padding(.trailing, 15)
                }
            }
        }
    }
}

struct ProfileAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAvatarView(sAvatarUrl: "https://avatars.githubusercontent.com/u/6470403?v=4", name: "Russell Archer")
    }
}
