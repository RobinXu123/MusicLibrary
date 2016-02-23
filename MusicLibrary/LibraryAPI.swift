//
//  LibraryAPI.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

//private let sharedInstance = LibraryAPI()

class LibraryAPI: NSObject {
    
    static let sharedInstance = LibraryAPI()
    
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private let isOnline: Bool

//    class var sharedAPI: LibraryAPI {
//        return sharedInstance
//    }
    
    private override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
//    class var sharedInstance: LibraryAPI {
//        struct Singleton {
//            static let instance = LibraryAPI()
//        }
//        return Singleton.instance
//    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "(index)")
        }
    }
    
    func downloadImage(notification: NSNotification) {
        //1
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imageView = userInfo["imageView"] as! UIImageView?
        let coverUrl = userInfo["coverUrl"] as! NSString
        
        //2
        if let imageViewUnWrapped = imageView {
            imageViewUnWrapped.image = persistencyManager.getImage(coverUrl.lastPathComponent)
            if imageViewUnWrapped.image == nil {
                //3
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let downloadedImage = self.httpClient.downloadImage(coverUrl as String)
                    //4
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        imageViewUnWrapped.image = downloadedImage
                        self.persistencyManager.saveImage(downloadedImage, filename: coverUrl.lastPathComponent)
                    })
                })
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
