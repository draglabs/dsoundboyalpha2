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
  enum Commons {
    struct Request{}
    struct Response{
      let jamActive:Bool
    }
    struct ViewModel{
      let jamActive:Bool
    }
  }

  enum Progress {
    struct Request {}
    struct Response {
      let progress:Float
    }
    struct ViewModel {
      let progress:String
    }
  }
  
  enum JamActive {
    struct Request{}
    struct Response{
      let isActive:Bool
    }
    struct ViewModel{
      let isActive:Bool
    }
  }
  
  enum Jam {
    struct Request{}
    struct Response{
      let pin:String
    }
    struct ViewModel{
      let pin:String
    }
  }
  
  enum JamUpload {
    struct Request {}
    struct Response {}
    struct ViewModel {}
  }
  
  
}
