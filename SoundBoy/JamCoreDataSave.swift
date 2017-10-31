//
//  JamCoreDataSave.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class  JamStore:StoreRepresentable {
 
    let coreDataStore = CoreDataStore(entity: .jam)
  
  func from(data: Data, response: @escaping (Result<Any>) -> ()) {
    let decorder = JSONDecoder()
    let resp = try? decorder.decode(JamResponse.self, from: data)
    guard let jamRes = resp else{response(Result.failed(message: "unable to parse response", error: nil)); return}
    
    let context = coreDataStore.viewContext
    var jamToSave = Jam(context: context)
    if let existingJam = jamExist(resp: jamRes) {
      existingJam.id = jamRes.jam.id
      existingJam.pin = jamRes.jam.pin
      existingJam.startTime = jamRes.jam.startTime
      existingJam.endTime = jamRes.jam.endTime
      existingJam.isCurrent = true
      jamToSave = existingJam
    }else {
      jamToSave.id = jamRes.jam.id
      jamToSave.pin = jamRes.jam.pin
      jamToSave.startTime = jamRes.jam.startTime
      jamToSave.endTime = jamRes.jam.endTime
      jamToSave.isCurrent = true
    }
    
    context.perform {
      do {
        try context.save()
        response(Result.success(data: jamToSave))
      }catch {
        response(Result.failed(message: "Unable to save jam", error: error))
      }
    }
  }
  
  func jamExist(resp:JamResponse) ->Jam? {
   
    var jam:Jam?
    let context = coreDataStore.viewContext
    let predicate = NSPredicate(format: "id == %@", resp.jam.id)
    let request:NSFetchRequest = Jam.fetchRequest()
    request.predicate = predicate
    context.performAndWait {
      do  {
        let result = try request.execute()
        print("result from exist", result.count)
        if result.count > 0 {
          jam = result.first
        }
        
      }catch {
        fatalError()
      }
      
    }
    
    return jam
  }
  
}
