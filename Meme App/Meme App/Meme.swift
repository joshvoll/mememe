//
//  Meme.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/20/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    
    // global properties
    let topText:String!
    let bottomText:String!
    let originalImage:UIImage!
    let memeImage:UIImage!
    
    
    // MARK: init method for saveing the data
    init(topText:String, bottomText:String, originalImage:UIImage, memeImage:UIImage){
        
        self.topText       = topText
        self.bottomText    = bottomText
        self.originalImage = originalImage
        self.memeImage     = memeImage
    }
    
}
