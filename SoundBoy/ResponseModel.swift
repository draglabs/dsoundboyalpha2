//
//  UserActivityResponseModel.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 10/18/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
struct UserActivityResponseCordinates:Decodable {
  
}
struct UserActivityResponsCreator:Decodable {
  var email:String
  var id:String
  var name:String
}

struct UserActivityResponse: Decodable {
  var collaboratorCount:Int
  var endTime:String
  var id:String
  var startTime:String
  var location:String
  var name:String
  var creator: UserActivityResponsCreator
  
}
//=======JamResponse===============
struct JamResponse:Decodable {
  var id:String
  var pin:String
  var startTime:String
  var endTime:String
}

//=======UserResponse===============
struct Usr:Codable {
  var id:String
  var name:String
  var lastName:String
  
  enum CodingKeys:String,CodingKey {
    case id = "id"
    case name = "first_name"
    case lastName = "last_name"
  }
}
struct UserResponse:Codable {
  var user:Usr
  enum CodingKeys:String,CodingKey {
    case user = "user"
  }
}

struct JoinJamResponse:Decodable {
  
}
