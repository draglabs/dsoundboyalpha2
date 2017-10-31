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
  // MARK: DisplayCurrentJam
  
  func currentJam(request: EditJam.CurrentJam.Request){
    location.didGetLocation = {[weak self] location, address in
      let loc = "\(address.number!) \(address.street)"
      let notes = "Recorded at \(loc)"
      self?.presenter?.presentCurrentJam(response: EditJam.CurrentJam.Response(name: "", location: loc, notes: notes))
    }
    location.requestLocation()
  }
  
  func update(request:EditJam.Update.Request) {
    
  }
  
  func prepareForUpdate(completion:@escaping()->()) {
   
  }
}
