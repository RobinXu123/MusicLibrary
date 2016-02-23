//
//  HTTPClient.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

class HTTPClient {
    
    func getRequest(url: String) -> AnyObject {
        return NSData()
    }
    
    func postRequest(url: String, body: String) -> AnyObject {
        return NSData()
    }
    
    func downloadImage(url: String) -> UIImage {
        let aUrl = NSURL(string: url)
        let data = NSData(contentsOfURL: aUrl!)
        let image = UIImage(data: data!)
        return image!
    }
    
}
