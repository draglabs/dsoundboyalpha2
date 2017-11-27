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
 
}

class EditJamInteractor: EditJamBusinessLogic, EditJamDataStore {
  var presenter: EditJamPresentationLogic?
  var worker: EditJamWorker?
  let jamWorker = JamWorker()
  let location = LocationWorker()
  let jamFetcher = JamFetcher()
  let userFetcher = UserFether()
  // MARK: DisplayCurrentJam
  
  func currentJam(request: EditJam.CurrentJam.Request){
    jamFetcher.fetch { (jam, err) in
      if let jam = jam {
        var location = ""
        var notes = ""
        if jam.location != nil {location = jam.location!}
        if jam.notes != nil{notes = jam.notes!}
       self.presenter?.presentCurrentJam(response: EditJam.CurrentJam.Response(name: jam.name!, location: location, notes:notes))
      }
    }
//    location.didGetLocation = {[weak self] location, address in
//      let loc = "\(address.number!) \(address.street)"
//      let notes = "Recorded at \(loc)"
//      self?.presenter?.presentCurrentJam(response: EditJam.CurrentJam.Response(name: "", location: loc, notes: notes))
//    }
//    location.requestLocation()
  }
  
  func update(request:EditJam.Update.Request) {
    let loc = request.location
    let name = request.name
    let notes = request.notes
    
    prepareForUpdate {[weak self] (jamId) in
      let updates = ["id":jamId, "name":name,"location":loc,"notes":notes]
      self?.jamWorker.update(updates: updates, completion: { (result) in
        switch result {
        case .success:
          self?.presenter?.presentUpdated(response: EditJam.Update.Response(updated: true))
        case .failed:
          self?.presenter?.presentUpdated(response: EditJam.Update.Response(updated: false))
        }
      })
    }
  }
  
  func prepareForUpdate(completion:@escaping(String)->()) {
    jamFetcher.fetch { (jam, err) in
      if let j  = jam {
        completion(j.id!)
      }
    }
  }
}
