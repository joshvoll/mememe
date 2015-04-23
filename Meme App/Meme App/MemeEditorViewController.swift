//
//  MemeEditorViewController.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/15/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit


class MemeEditorViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // global properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextMeme: UITextField!
    @IBOutlet weak var bottomTextMeme: UITextField!
    @IBOutlet weak var camaraButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    // meme attributes properties
    let memeTextAtrributes = [
        // load attributes
        NSStrokeColorAttributeName:UIColor.blackColor(),
        NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size:40)!,
        NSStrokeWidthAttributeName: -1.0
    ]
    
    // app delegate instance, going to save to the table view
    let appDelegateInstance    = UIApplication.sharedApplication().delegate as! AppDelegate
    // intanst of classes
    let inputTextFieldDelegate = InputTextFieldDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load and make sure camara if camara is available
        initSetup()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // subscribe to keyboard notification
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK:Methods
    func initSetup(){
        
        // check if the camara is available
        camaraButton.enabled                      = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // setup text attributes
        self.topTextMeme.defaultTextAttributes    = memeTextAtrributes
        self.bottomTextMeme.defaultTextAttributes = memeTextAtrributes
        // initilize value
        self.topTextMeme.text                     = "TOP"
        self.bottomTextMeme.text                  = "BOTTOM"
        // alignment
        self.topTextMeme.textAlignment            = .Center
        self.bottomTextMeme.textAlignment         = .Center
        // text delegates
        self.topTextMeme.delegate                 = self.inputTextFieldDelegate
        self.bottomTextMeme.delegate              = self.inputTextFieldDelegate
        // borders style
        self.topTextMeme.borderStyle              = UITextBorderStyle.None
        self.bottomTextMeme.borderStyle           = UITextBorderStyle.None
        
        
    }
    
    
    // share Methods
    @IBAction func shareMemeImage(sender: AnyObject) {
        // first generate the image that we going to share
        let memedImage = generateMemedImage()
        // create the view controller
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // load the view controller
        activityController.completionWithItemsHandler = { (activity, success, items, errors) in
            
            // if !success cancel the photo saving
            if !success {
                println("Shared cancelled")
                return
            }
            
            // shared good
            self.save()
            self.dismissController()
        }
        
        self.presentViewController(activityController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancelMemeImage(sender: AnyObject) {
        // print cancel meme
        self.dismissController()
    }
    // image from camara method
    @IBAction func pickImageFromCamara(sender: AnyObject) {
        // load the picker controller
        let pickerImageController        = UIImagePickerController()
        pickerImageController.delegate   = self
        pickerImageController.sourceType = UIImagePickerControllerSourceType.Camera
        
        // load the camara controller
        self.presentViewController(pickerImageController, animated: true, completion: nil)
    }
    
    // image from album method
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        // load the picker image 
        let pickerImageController        = UIImagePickerController()
        pickerImageController.delegate   = self
        pickerImageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // load the photo library controller
        self.presentViewController(pickerImageController, animated: true, completion: nil)
    }
    
    
    // MARK: picked image controller methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // if he take the image dismiss the window
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // load the image that the user picks
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            // change the image on the slide
            self.imageView.image = image
        }
        // dismiss the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: subscribe keyboard notifications
    func subscribeToKeyboardNotifications(){
        // get notification of the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // keyBoardWillShow notification, this will send the notification to a keyboard hight method
    func keyBoardWillShow(notification:NSNotification){
        // if the text field is bottom
        if bottomTextMeme.isFirstResponder() {
            
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    // keyBoardWillHide this notification
    func keyBoardWillHide(notification:NSNotification){
        // return the keyboard notification
        self.view.frame.origin.y += getKeyBoardHeight(notification)
    }
    
    // keyBoardWillShow get the keyboard notification
    func getKeyBoardHeight(notification:NSNotification) -> CGFloat{
        // get the keyboard notification
        let userInfo     = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        // return the value for the keyboard hide
        if bottomTextMeme.editing {
            return keyBoardSize.CGRectValue().height
        }else{
            return 0
        }
    }
    
    // MARK: unsubscribe Keyboard notifications
    func unsubscribeFromKeyboardNotifications(){
        // unsubscribe for the notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: Save method for the meme editor
    func save(){
        
        // send the meme image to the Meme struct
        var meme = Meme(topText: self.topTextMeme.text!, bottomText: self.bottomTextMeme.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
        
        // put everything to the app delegate
        self.appDelegateInstance.memes.append(meme)
    }
    
    // imagedMeme
    func generateMemedImage() -> UIImage {
        
        // first let hide the screen toolbars
        self.topToolBar.hidden    = true
        self.bottomToolBar.hidden = true
        
        // generates the images with the two text
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        // assign imageMemed to a property
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // put the toolbar and navbar
        self.topToolBar.hidden    = false
        self.bottomToolBar.hidden = false
        
        // return the images to the save functions
        return memedImage
    }
    
    
    
    // MARK: other methods
    func dismissController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
}


