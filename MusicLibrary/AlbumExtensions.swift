//
//  AlbumExtensions.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/23.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

extension Album {
    
    func ae_tableRepresentation() -> (titles: [String], values: [String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
    
}