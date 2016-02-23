//
//  ViewController.swift
//  MusicLibrary
//
//  Created by Robin on 16/2/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var allAlbums = [Album]()
    private var currentAlbumData : (titles:[String], values:[String])?
    private var currentAlbumIndex = 0
    
    // 为了实现撤销功能，我们用数组作为一个栈来 push 和 pop 用户的操作
    var undoStack: [(Album, Int)] = []

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scroller: HorizontalScroller!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        currentAlbumIndex = 0
        
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        dataTable.dataSource = self
        dataTable.delegate = self
        dataTable.backgroundView = nil
//        view.addSubview(dataTable)
        
        self.showDataForAlbum(currentAlbumIndex)
        
        loadPreviousState()
        scroller.delegate = self
        reloadScroller()
        
        let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action:"undoAction")
        undoButton.enabled = false;
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target:nil, action:nil)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target:self, action:"deleteAlbum")
        let toolbarButtonItems = [undoButton, space, trashButton]
        toolbar.setItems(toolbarButtonItems, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAlbumAtIndex(album: Album,index: Int) {
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
    
    func deleteAlbum() {
        //1
        let deletedAlbum : Album = allAlbums[currentAlbumIndex]
        //2
        let undoAction = (deletedAlbum, currentAlbumIndex)
        undoStack.insert(undoAction, atIndex: 0)
        //3
        LibraryAPI.sharedInstance.deleteAlbum(currentAlbumIndex)
        reloadScroller()
        //4
        let barButtonItems = toolbar.items! as [UIBarButtonItem]
        let undoButton : UIBarButtonItem = barButtonItems[0]
        undoButton.enabled = true
        //5
        if (allAlbums.count == 0) {
            let trashButton : UIBarButtonItem = barButtonItems[2]
            trashButton.enabled = false
        }
    }
    
    func undoAction() {
        let barButtonItems = toolbar.items! as [UIBarButtonItem]
        //1
        if undoStack.count > 0 {
            let (deletedAlbum, index) = undoStack.removeAtIndex(0)
            addAlbumAtIndex(deletedAlbum, index: index)
        }
        //2
        if undoStack.count == 0 {
            let undoButton : UIBarButtonItem = barButtonItems[0]
            undoButton.enabled = false
        }
        //3
        let trashButton : UIBarButtonItem = barButtonItems[2]
        trashButton.enabled = true
    }

    func showDataForAlbum(albumIndex: Int) {
        
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            
            let album = allAlbums[albumIndex]
            
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        
        dataTable.reloadData()
    }
    
    func reloadScroller() {
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if currentAlbumIndex >= allAlbums.count {
            currentAlbumIndex = allAlbums.count - 1
        }
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
    
    //MARK: Memento Pattern
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
        LibraryAPI.sharedInstance.saveAlbums()
    }
    
    func loadPreviousState() {
        currentAlbumIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
        showDataForAlbum(currentAlbumIndex)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAlbumData?.titles.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if let albumData = currentAlbumData {
            cell.textLabel?.text = albumData.titles[indexPath.row]
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = albumData.values[indexPath.row]
            }
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: HorizontalScrollerDelegate {
    
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        //1
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(didHighlightView: false)
        //2
        currentAlbumIndex = index
        //3
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        albumView.highlightAlbum(didHighlightView: true)
        //4
        showDataForAlbum(index)
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRectMake(0, 0, 100, 100), albumCover: album.coverUrl)
        if currentAlbumIndex == index {
            albumView.highlightAlbum(didHighlightView: true)
        } else {
            albumView.highlightAlbum(didHighlightView: false)
        }
        
        return albumView
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return allAlbums.count
    }
    
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        return currentAlbumIndex
    }
}

