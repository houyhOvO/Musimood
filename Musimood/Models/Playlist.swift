//
//  Playlist.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import SwiftData
import SwiftUI
import Foundation

@Model
class Playlist {
    var name: String
    var artworkData: Data?
    
    @Relationship(deleteRule: .cascade)
    var songs: [Song] = []
    
    init(name: String, artworkData: Data? = nil) {
        self.name = name
        self.artworkData = artworkData
    }
    
    var artworkImage: Image {
        if let data = artworkData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "music.note.list")
        }
    }
}
