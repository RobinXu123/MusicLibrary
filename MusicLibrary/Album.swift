//
//  Album.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    
    var title : String!
    var artist : String!
    var genre : String!
    var coverUrl : String!
    var year : String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObjectForKey("title") as! String?
        self.artist = aDecoder.decodeObjectForKey("artist") as! String?
        self.genre = aDecoder.decodeObjectForKey("genre") as! String?
        self.coverUrl = aDecoder.decodeObjectForKey("cover_url") as! String?
        self.year = aDecoder.decodeObjectForKey("year") as! String?
    }
    
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        super.init()
        
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    override var description: String {
        return "title: \(title)" +
            "artist: \(artist)" +
            "genre: \(genre)" +
            "coverUrl: \(coverUrl)" +
            "year: \(year)"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(coverUrl, forKey: "cover_url")
        aCoder.encodeObject(year, forKey: "year")
    }

}
