//
//  EditJamModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum EditJam
{
  // MARK: Use cases
  
  enum CurrentJam{
    struct Request {
     
    }
    struct Response {
      var  name:String?
      let location:String
      let notes:String
    }
    struct ViewModel{
      let  name:String
      let location:String
      let notes:String
    }
  }
  enum Update {
    struct Request{
      let name:String
      let location:String
      let notes:String
    }
    struct Response {
      let updated:Bool
    }
    struct ViewModel {
      let updated:Bool
    }
  }
}
