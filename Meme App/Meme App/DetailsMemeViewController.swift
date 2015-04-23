//
//  DetailsMemeViewController.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/22/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit


class DetailsMemeViewController:UIViewController {
    
    // global properties
    var meme:Meme!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // outlet property
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the images
        self.detailImageView.image = meme.memeImage
    }
}