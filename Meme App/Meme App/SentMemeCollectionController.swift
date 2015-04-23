//
//  SentMemeCollectionController.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/20/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionController:UICollectionViewController, UICollectionViewDataSource {
    
    // MARk: Global properties
    var memes:[Meme]!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // update memes
        self.updateMemes()
    }
    
    // get the collections
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return of the counts of the sections
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memesCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewControllerCell
        // get the array from meme
        let meme             = self.memes[indexPath.row]
        cell.imageView.image = meme.memeImage
        
        return cell
        
    }
    
    // send to the details meme
     override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // assign the view controller to a property
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsMemeViewController
        // load the meme
        detailVC.meme = self.memes[indexPath.row]
        // push the view controller
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    // get the array from the app delegates
    func updateMemes(){
        // memes delegates
        self.memes = appDelegate.memes
        // reload the data
        self.collectionView?.reloadData()
    }
    
    @IBAction func createNewMeme(sender: AnyObject) {
        // call the meme editor method
        self.loadMemeEditor()
    }
    
    // load meme editor
    func loadMemeEditor(){
        
        let showMemeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // show the editor
        self.presentViewController(showMemeEditor, animated: true, completion: nil)
        
    }
    
}
