//
//  RequestParameters.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 1/17/18.
//  Copyright © 2018 DragLabs. All rights reserved.
//

import Foundation

enum JamParameters {
  struct new:Codable {}
  struct upload:Codable{}
  struct join:Codable {}
  struct export:Codable{}
  struct details{}
  
  struct update:Codable {
    var name:String?
    var location:String?
    var notes:String?
  }
}

 enum UserParameters {
  struct register:Codable{
    let token:String
    let facebookId:String
    
   private enum CodingKeys:String,CodingKey {
      case token = "access_token"
      case facebookId = "facebook_id"
    }
  }
  
}

