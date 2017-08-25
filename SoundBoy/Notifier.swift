//
//  Notifier.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/6/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let shouldStartRecording = NSNotification.Name("should.start.recording")
    static let didStartRecording    = NSNotification.Name("did.start.recoding")
    static let didEndRecording      = NSNotification.Name("did.end.recording")
    static let audioDidUpload       = NSNotification.Name("audio.did.upload")
    static let audioIsUploading     = NSNotification.Name("audio.is.uploading")
    static let willStartJam         = NSNotification.Name("will.start.jam")
    static let didSubmitStartJam    = NSNotification.Name("did.submit.start.jam")
    
}
