//
//  SentMemeViewController.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/14/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit


class SentMemeViewController:UITableViewController, UITableViewDataSource{

    var memes:[Meme]!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // if the appdelegate array is empty, show the meme editor
        if appDelegate.memes.count == 0 {
            self.loadMemeEditor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // load the array from AppDelagate class
        self.memes = appDelegate.memes
        // refresh the data
        self.tableView.reloadData()
    }
    
    // table counts
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the memes count
        return self.memes.count
    }
    
    // cell of table row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get the prototype cell
        let cell              = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath:indexPath) as! UITableViewCell
        let meme              = self.memes[indexPath.row]
        cell.imageView?.image = meme.memeImage
        cell.textLabel!.text  = meme.topText
        
        // return the cell
        return cell
    }
    
    // if the user select the item
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // assing the view controller to a property
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailsVC") as! DetailsMemeViewController
        // load the meme
        detailsVC.meme = self.memes[indexPath.row]
        // push the view controller
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: Action buttons
    @IBAction func createNewMeme(sender: AnyObject) {
        // load the new meme editor
        self.loadMemeEditor()
    }
    
    func loadMemeEditor(){
        let showEditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        // load the editor
        self.presentViewController(showEditorViewController, animated: true, completion: nil)

    }
}