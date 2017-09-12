//
//  MainModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

enum Main
{
  // MARK: Use cases
  
  enum Jam {
    struct Request{}
    struct Response{}
    struct ViewModel{
      let pin:String
      let didStart:Bool
    }
  }
  
  enum JamUpload {
    struct Request {
      let fileURL:URL
    }
    struct Response {}
    struct ViewModel {}
  }
  
  
}
