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
    let d = Parser().parse(to: .json, from: data)
    print(d ?? "")
    let resp = try? decorder.decode(JamResponse.self, from: data)
   
    guard let jamRes = resp else{response(Result.failed(message: "unable to parse response", error: nil)); return}
 
    let context = coreDataStore.viewContext
    
     var jamToSave = Jam(context: context)
    if let existingJam = jamExist(resp: jamRes) {
      existingJam.id = jamRes.id
      existingJam.pin = jamRes.pin
      existingJam.startTime = jamRes.startTime
      existingJam.endTime = jamRes.endTime
      existingJam.isCurrent = true
      jamToSave = existingJam
    }
      jamToSave.name = jamRes.name
      jamToSave.id = jamRes.id
      jamToSave.pin = jamRes.pin
      jamToSave.startTime = jamRes.startTime
      jamToSave.endTime = jamRes.endTime
      jamToSave.isCurrent = true
    
    context.perform {
      do {
        try context.save()
        response(Result.success(data: jamToSave))
      }catch {
        print("not saved",error)
        response(Result.failed(message: "Unable to save jam", error: error))
      }
    }
  }
  
  func jamExist(resp:JamResponse) ->Jam? {
   
    var jam:Jam?
    let context = coreDataStore.viewContext
    let predicate = NSPredicate(format: "id == %@", resp.id)
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
