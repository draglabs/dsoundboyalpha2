//
//  StartJamTest.swift
//  dSoundBoyTests
//
//  Created by Marlon Monroy on 9/20/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import XCTest
@testable import dSoundBoy
class StartJamTest: XCTestCase {
  let enviroment = Enviroment("Test", host: "")
  var dispatcher:DefaultDispatcher!
  let startJam = StartJamWorker()
  
  override func setUp() {
    super.setUp()
    dispatcher = DefaultDispatcher(enviroment: enviroment)
  }
  
  func testStart() {
   
  }
  
    
}
