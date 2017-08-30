//
//  Jam.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

class Jam {
    let pin:String
    let uniqueId:String
    let jamLocation:String
    let jamName:String
    let jamLat:String
    let jamLong:String
    let jamId:String
    let jamStartTime:String
    let jamEndTime:String
    
    init?(_ json:JSONDictionary) {
       
        guard let jam = json["jam"] as? JSONDictionary,
        let id = jam["jamID"] as? String,
        let pin = jam["pin"] as? String,
        let startTime = jam["startTime"] as? String,
        let endTime = jam["endTime"] as? String
        else { return nil }
        
        self.uniqueId = ""
        self.jamLocation = ""
        self.jamName = ""
        self.jamLat = ""
        self.jamLong = ""
        self.jamId = id
        self.jamStartTime = startTime
        self.jamEndTime = endTime
        self.pin = pin
    }
}
