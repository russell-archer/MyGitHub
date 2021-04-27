//
//  ImageLoader.swift
//  MyGitHub
//
//  Created by Russell Archer on 22/04/2021.
//

import SwiftUI

struct ImageLoader {
    
    static func load(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    static func load(url: String) -> UIImage? {
        guard let u = URL(string: url) else { return nil }
        return load(url: u)
    }
}
