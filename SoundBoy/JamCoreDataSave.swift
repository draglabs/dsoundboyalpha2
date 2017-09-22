//
//  JamCoreDataSave.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class  JamStore: StoreRepresentable {
  let coreDataStore = CoreDataStore(entity: .jam)
  var userFetchResult:((_ user:User?,_ error:Error?)->())?
  
  func fromData(data: Data, response: @escaping (Bool) -> ()) {
    //MARK:TODO Finish implementaion
  }
  func fromJSON(json: JSONDictionary, response: @escaping (Bool) -> ()) {
    print(json)
    
   
    if let error = json["error"] as? String {
      print(error)
      return
    }
    
    guard let jam = json["jam"] as? JSONDictionary else {
      response(false)
      return
    }
    
    guard let id = jam["id"] as? String, let pin = jam["pin"] as? String,
      let startTime = jam["startTime"] as? String, let endTime = jam["endTime"] as? String
      else {
        response(false)
        return
    }
    
    let context = coreDataStore.viewContext
    let jamToSave = Jam(context: context)
    jamToSave.id = id
    jamToSave.pin = pin
    jamToSave.startTime = startTime
    jamToSave.endTime = endTime
    jamToSave.isCurrent = true
    coreDataStore.save(completion: response)
  }

}
