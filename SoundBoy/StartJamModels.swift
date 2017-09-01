//
//  StartJamModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum StartJam  {
  // MARK: Use cases
  
    enum Textfields {
        struct Request {}
        struct Response {}
        
        struct ViewModel {
            let jamName = "Enter jam name"
            let locationName = "Enter jam Location (i.e my house)"
            let close = "Close"
            let done = "DONE"
        }
    }
    
    
    
  enum Submit {
    struct Request {
        var name:String
        var location:String
    }
    struct Response {
        var jam:Jam
    }
    struct ViewModel {}
  }
    
    
    
enum Success {
    struct Request {
        let success:Bool
    }
    struct Response {
        let success:Bool
    }
    struct ViewModel {}
  }
    
}
