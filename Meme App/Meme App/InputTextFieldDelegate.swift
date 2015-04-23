//
//  InputTextFieldDelegate.swift
//  Meme App
//
//  Created by Josue Rodriguez on 4/20/15.
//  Copyright (c) 2015 Josue Rodriguez. All rights reserved.
//

import Foundation
import UIKit


class InputTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var vc: MemeEditorViewController?
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
