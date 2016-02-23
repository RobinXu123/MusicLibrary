//
//  AlbumView.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        coverImage.addObserver(self, forKeyPath: "image", options: [], context: nil)
        
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
        
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView":coverImage, "coverUrl" : albumCover])
    }
    
    func highlightAlbum(didHighlightView didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: "image")
    }

}
