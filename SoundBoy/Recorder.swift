//
//  Recorder.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/29/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import AVFoundation
import AVKit


class Recorder: NSObject,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
  
    var willStartRecording:(()->())?
    var willFinishRecording:(()->())?
    var didFinishRecording:((_ url:URL)->())?
    var audioFilename:URL!
  
    var isRecording = false
    var trackName   = "track"
    var startedTime = Date()
    var endTime     = Date()
  
    private var docs:URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    static let shared = Recorder()
    override private init() {
        super.init()
        prepareSession()
    }
    
    func prepareSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        //self.loadRecordingUI()
//                    } else {
//                        // failed to record!
//                    }
//                }
            }
        } catch {
            fatalError("cant initiate session, Error: \(error)")
        }
    }
    
    func startRecording() {
      print("Recorder will beggin recording")
         audioFilename = docs.appendingPathComponent("\(trackName).caf")
        
        let settings = [
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            startedTime = Date(timeIntervalSince1970: NSTimeIntervalSince1970)
            isRecording = true
           willStartRecording?()
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func stopRecording() {
      print("Recorder will stop recording")
        isRecording = false
        willFinishRecording?()
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    
   private func finishRecording(success:Bool) {
        isRecording = false
        willFinishRecording?()
        audioRecorder.stop()
        audioRecorder = nil
        if !success {
            print("notify the user for failing to record")
        }
        
    }
  
}

// Recording protocol conformance
extension Recorder {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("did finish recording",recorder.url)
        didFinishRecording?(recorder.url)
        endTime = Date(timeIntervalSince1970: NSTimeIntervalSince1970)
      
        print(recorder.currentTime)
    }

    
    
}
