//
//  AudioUploaderOperation.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

final class AudioUploaderOperation: baseOperation {
    var session:URLSession {
       let sessionConfig = URLSessionConfiguration()
        return URLSession(configuration: sessionConfig)
    }
   
    
    override func exacute() {
     
    }
    

    convenience init(audioFile:AudioFile)  {
        self.init()
        
    }

    
    func startUploading() {
        
    }
}


extension AudioUploaderOperation:URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        
        
    }

}
