//
//  dSoundBoyTests.swift
//  dSoundBoyTests
//
//  Created by Marlon Monroy on 9/20/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import XCTest
@testable import dSoundBoy

class UserLoginTest: XCTestCase {
  var fbAPi:FacebookAPI!
  
  
  override func setUp() {
    super.setUp()
    fbAPi = FacebookAPI()
  }
  
  func testLogin() {
    
    let xpt = expectation(description:"Should log an user in")
    fbAPi.loginUser { (logged) in
      XCTAssertTrue(logged)
      xpt.fulfill()
    }
    waitForExpectations(timeout: (3)) { (error) in
      if let err = error {
        XCTFail("login did failt with error:\(err)")
      }
    }
  }
  
}
