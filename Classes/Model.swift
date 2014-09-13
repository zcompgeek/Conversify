//
//  Model.swift
//  Conversify
//
//  Created by Zach Costa on 9/12/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

/// Parent model for Conversify. Holds some of the most generic model functions.
class Model {
    
    var databasePath : String = ""
    
    func Model (path: String) {
        databasePath = path;
    }
    
}

