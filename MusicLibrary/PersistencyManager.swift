//
//  PersistencyManager.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    private var albums : [Album] = []
    
    override init() {
        super.init()
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")) {
            let unarchiveAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Album]?
            if let unwrappedAlbum = unarchiveAlbums {
                albums = unwrappedAlbum
            }
        } else {
            createPlaceholderAlbum()
        }
    }
    
    func createPlaceholderAlbum() {
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
            artist: "David Bowie",
            genre: "Pop",
            coverUrl: "http://img.xiami.net/images/album/img80/78980/4142851382406916_2.jpg",
            year: "1992")
        
        let album2 = Album(title: "It's My Life",
            artist: "No Doubt",
            genre: "Pop",
            coverUrl: "http://img.xiami.net/images/album/img58/7158/11364555381447059552_2.jpg",
            year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
            artist: "Sting",
            genre: "Pop",
            coverUrl: "http://img.xiami.net/images/album/img71/10171/523231376990436_2.jpg",
            year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
            artist: "U2",
            genre: "Pop",
            coverUrl: "http://img.xiami.net/images/album/img60/63760/3414911358479166_2.jpg",
            year: "2000")
        
        let album5 = Album(title: "American Pie",
            artist: "Madonna",
            genre: "Pop",
            coverUrl: "http://img.xiami.net/images/album/img33/56333/4871021390395891_2.jpg",
            year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
        saveAlbums()
    }
    
    func saveAlbums() {
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
        data.writeToFile(filename, atomically: true)
    }
    
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if (albums.count >= index) {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        albums.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        if let data = UIImagePNGRepresentation(image) {
            data.writeToFile(path, atomically: true)
        }
    }
    
    func getImage(filename: String) -> UIImage? {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        do {
            let data = try NSData(contentsOfFile: path, options: .UncachedRead)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

}
