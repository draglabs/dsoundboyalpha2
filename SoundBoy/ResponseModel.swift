//
//  UserActivityResponseModel.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 10/18/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

struct UserActivityResponsCreator:Codable {
  var email:String
  var id:String
  var name:String
}

//=======JamResponse===============
struct JamResponse:Codable {
  var name:String?
  var id:String
  var pin:String?
  var isCurrent:Bool?
  var location:String?
  var startTime:String
  var endTime:String?
  var notes:String?
  var link:String?
  var collaborators:Int?
  
  enum CodingKeys:String,CodingKey{
    case name
    case id
    case pin
    case location
    case collaborators
    case notes
    case link
    case startTime = "start_time"
    case endTime = "end_time"
    case isCurrent = "is_current"
  }
}

//=======UserResponse===============
struct UpdateParams:Codable {
  
  var id:String
  var name:String
  var location:String
  var notes:String
}
struct UserResponse:Codable {
  var id:String
  var name:String
  var lastName:String
  
  enum CodingKeys:String,CodingKey {
    case id = "id"
    case name = "first_name"
    case lastName = "last_name"
  }
}

struct JamDetailResponse:Decodable {
  
}
