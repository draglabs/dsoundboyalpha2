//
//  baseOperation.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

class baseOperation: Operation {
    override  var isAsynchronous: Bool {
        return true
    }
    
    override var isConcurrent: Bool {
        return true
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
    
    
    override func start() {
        _executing = true
        exacute()
    }
    
    func exacute() {
        fatalError("Must override this method")
    }
}
