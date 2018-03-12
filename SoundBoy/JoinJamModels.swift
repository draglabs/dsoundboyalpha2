//
//  JoinJamModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum JoinJam
{
  // MARK: Use cases
  enum Join {
    struct Request {
      let pin:String
    }
    struct Response {
      let didJoin:Bool
    }
    struct ViewModel {
      let didJoin:Bool
    }
  }
  
  enum Commons
  {
    struct Request{}
    struct Response{}
    struct ViewModel
    {
      let joinTxt = "JOIN"
      let pinTxt = "enter pin"
      let labelTxt = "Please enter Jam pin"
      
    }
  }
}
