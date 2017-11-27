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
      delete()
     let jamToSave = Jam(context: context)
    
      jamToSave.name = jamRes.name
      jamToSave.id = jamRes.id
      if jamRes.pin == nil{
        jamToSave.isJoined = true
      }
      jamToSave.pin = jamRes.pin
      jamToSave.location = jamRes.location
      jamToSave.startTime = jamRes.startTime
      jamToSave.endTime = jamRes.endTime
      jamToSave.notes = jamRes.notes
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
  
  func delete(){
    let context = coreDataStore.viewContext
    let request:NSFetchRequest = Jam.fetchRequest()
    
    context.performAndWait {
      do  {
        let result = try request.execute()
        print("result from exist", result.count)
        if result.count > 0 {
          context.delete(result.first!)
        }
        
      }catch {
        fatalError()
      }
      
    }
    
  }
  
}
