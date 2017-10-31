//
//  ExportJamModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/26/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum ExportJam
{
  // MARK: Use cases
  
  enum Export{
    struct Request{}
    struct Response {
      let message:String
    }
    struct ViewModel {
      let message:String
    }
  }
}
