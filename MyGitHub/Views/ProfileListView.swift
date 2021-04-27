//
//  ProfileListView.swift
//  MyGitHub
//
//  Created by Russell Archer on 23/04/2021.
//

import SwiftUI

struct ProfileListView: View {
    var properties: [String : String]
    
    var body: some View {
        List {
            ForEach(properties.keys.sorted(), id: \.self) { key in
                VStack(alignment: .leading) {
                    Text(key).foregroundColor(.gray).padding(.bottom, 1)
                    Text(properties[key]!).foregroundColor(.purple).padding(.bottom, 1)
                }
            }
        }
    }
}

struct ProfileListView_Previews: PreviewProvider {
    
    static var previews: some View {
        var props = [String : String]()
        props["Test0"] = "Test Value0"
        props["Test1"] = "Test Value1"
        return ProfileListView(properties: props)
    }
}
