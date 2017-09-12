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
    
    if let exited = json["message"] as? String {
      exitedJam(response: response)
      print(exited)
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
    
    coreDataStore.save(completion: response)
  }

  private func exitedJam(response: @escaping (Bool) -> ()) {
    let context = coreDataStore.viewContext
    let request:NSFetchRequest = Jam.fetchRequest()
  
    context.perform {
      do {
        let result = try request.execute()
        if result.count > 0 {
          result.forEach({jam in
            context.delete(jam)
          })
          response(true)
        }
      }catch {
        fatalError("cant perform fetch for deletion \(error)")
      }
    }
    
  }
}
