//
//  StartJamTest.swift
//  dSoundBoyTests
//
//  Created by Marlon Monroy on 9/20/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import XCTest
@testable import dSoundBoy
class JamTest: XCTestCase {
 
  var jamWorker:JamWorker!
  
  override func setUp() {
    super.setUp()
    jamWorker = JamWorker()
  }
  
  func testStart() {
    let xpt = expectation(description: "should start a jam")
    jamWorker.startJam { (started) in
      XCTAssertTrue(started)
      xpt.fulfill()
    }
    waitForExpectations(timeout: (3)) { (error) in
      if let err = error {
        XCTFail("start jam did failed with error: \(err)")
      }
    }
  }
  
  func testJoin() {
    let xpt = expectation(description: "should join jam")
    jamWorker.joinJam(jamPin: "9294") { (joined) in
      XCTAssertTrue(joined)
      xpt.fulfill()
    }
    waitForExpectations(timeout:(3)) { (error) in
      if let err = error {
        XCTFail("joining jam did failed with error:\(err)")
      }
    }
  }
  
  func testExitJam() {
    let xpt = expectation(description: "should exit jam")
    jamWorker.exitJam { (exited) in
      XCTAssertTrue(exited)
      xpt.fulfill()
    }
    waitForExpectations(timeout: (3)) { (error) in
      if let err = error {
        XCTFail("exit jam failed with error: \(err)")
      }
    }
  }
  
}
