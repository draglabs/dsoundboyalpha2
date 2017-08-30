//
//  StartJamModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum StartJam
{
  // MARK: Use cases
  
  enum Submit
  {
    struct Request {
        var jam:Jam?
    }
    struct Response {
        var jam:Jam?
    }
    struct ViewModel {
        let jamName = "Enter jam name"
        let locationName = "Enter jam Location, i.e my house"
        let close = "Close"
        let done = "DONE"
    }
  }
}
