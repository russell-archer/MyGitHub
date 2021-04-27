//
//  ReposView.swift
//  MyGitHub
//
//  Created by Russell Archer on 24/04/2021.
//

import SwiftUI

struct ReposView: View {
    
    var repos: [Repository]
    
    var body: some View {

        List {
            
            ForEach(repos) { repo in
                Text(repo.name).foregroundColor(.purple).padding(.bottom, 1)
            }
        }
    }
}

struct ReposView_Previews: PreviewProvider {
    static var previews: some View {
        
        var r = [Repository]()
        r.append(Repository(id: 1, name: "Repo1"))
        r.append(Repository(id: 2, name: "Repo2"))
        r.append(Repository(id: 3, name: "Repo3"))

        return ReposView(repos: r)
    }
}
