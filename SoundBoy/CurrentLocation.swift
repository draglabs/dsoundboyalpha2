//
//  AudioFile.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import RealmSwift

struct CurrentLocation {
  var number:String?
  let street:String
  let city:String
  let state:String
  let zipCode:String
}

class RealmUserModel:Object {
  @objc dynamic var name:String = ""
  @objc dynamic var userID:String = ""
  
}

class RealmJamModel: Object {
  @objc dynamic var id:String = ""
  @objc dynamic var name:String = ""
  @objc dynamic var pin:String = ""
  @objc dynamic var location:String = ""
  @objc dynamic var notes:String = ""
  
  @objc func primaryKey() -> String? {
    return id
  }

}

class UserSettings: Object {
  @objc dynamic var wifiOnly:Bool = false
  @objc dynamic var quality:Int = 0
  
}

