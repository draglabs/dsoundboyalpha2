//
//  EditJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol EditJamBusinessLogic
{
  func currentJam(request: EditJam.CurrentJam.Request)
  func update(request:EditJam.Update.Request)
}

protocol EditJamDataStore {
 var jamId: String { get set }
}

class EditJamInteractor: EditJamBusinessLogic, EditJamDataStore {
  var presenter: EditJamPresentationLogic?
  var worker: EditJamWorker?
  let jamWorker = JamWorker()
  let location = LocationWorker()
  let jamFetcher = JamFetcher()
  let userFetcher = UserFether()
  let userWorker = UserActivityWorker()
  var jamId: String = ""
  // MARK: DisplayCurrentJam
  
  func currentJam(request: EditJam.CurrentJam.Request){
    if jamId.isEmpty {
    jamFetcher.fetch { (jam, err) in
      if let jam = jam {
        var location = ""
        var notes = ""
        self.jamId = jam.id!
        if jam.location != nil {location = jam.location!}
        if jam.notes != nil{notes = jam.notes!}
       self.presenter?.presentCurrentJam(response: EditJam.CurrentJam.Response(name: jam.name!, location: location, notes:notes))
        }
      }
    }else {
      jamFromFilesViews()
    }
  }
  func jamFromFilesViews() {
    userWorker.details(jamId: jamId) { (result) in
      switch result {
      case .success(let data):
        if let jam = data as? JamResponse {
          var location = ""
          var notes = ""
          if jam.location != nil {location = jam.location!}
          if jam.notes != nil{notes = jam.notes!}
          self.presenter?.presentCurrentJam(response: EditJam.CurrentJam.Response(name: jam.name!, location: location, notes:notes))
        }
      case .failed(let message, let error):
        print(message ?? "no message",error ?? "no error")
      }
    }
    print("should fetch new jam")
  }
  func update(request:EditJam.Update.Request) {
    let loc = request.location
    let name = request.name
    let notes = request.notes
    
   // prepareForUpdate {[weak self] (jamId) in
      let updates = ["id":jamId, "name":name,"location":loc,"notes":notes]
    self.jamWorker.update(updates: updates, completion: { (result) in
        switch result {
        case .success:
          self.presenter?.presentUpdated(response: EditJam.Update.Response(updated: true))
        case .failed:
          self.presenter?.presentUpdated(response: EditJam.Update.Response(updated: false))
        }
      })
   // }
  }
  
  func prepareForUpdate(completion:@escaping(String)->()) {
    jamFetcher.fetch { (jam, err) in
      if let j  = jam {
        completion(j.id!)
      }
    }
  }
}
