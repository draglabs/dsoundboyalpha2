//
//  User.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

import FacebookCore
import FacebookLogin

struct  User {
    var id:String
    var currentJam: Jam?
    
    public init?(json:JSONDictionary) {
        print(json)
        id = ""
        
    }
}


