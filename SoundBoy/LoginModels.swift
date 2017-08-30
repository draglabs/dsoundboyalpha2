//
//  LoginModels.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

enum Login
{
  // MARK: Use cases
  
  enum WelcomeText {
    struct Request{}
    struct Response{}
    struct ViewModel
    {
       let welcomeText:String = "Thank you for using dSoundBoy \n please sign up using"
    }
  }
  enum Register {
    struct Request {}
    struct Response {
        var registered:Bool
    }
    struct ViewModel {
        var registered:Bool
        }
    }
    
}
