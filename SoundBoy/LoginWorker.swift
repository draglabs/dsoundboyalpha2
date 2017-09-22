//
//  LoginWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

class LoginWorker {
  let location = LocationWorker()
  func requestPermisions() {
    location.requestLocation()
    Recorder.shared.prepareSession()
  }
}
