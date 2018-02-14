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
    private let formatter = DateFormatter()
    var startedTime = ""
    var endTime = ""
  
    private var docs:URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    static let shared = Recorder()
    override private init() {
        super.init()            //YYYY-MM-DDTHH:mm:ss // js
                                //yyyy-MM-dd HH:mm:ss // switt
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SS' 'Z"
        prepareSession()
    }
    
    func prepareSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
              print("User permisson for recording: \(allowed)")
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
          startedTime = formatter.string(from: Date())//date(from: String(describing:))
          //  startedTime = String(describing:Date())
            
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
        endTime = formatter.string(from: Date())
      // endTime = String(describing:Date())
    }

    
    
}
