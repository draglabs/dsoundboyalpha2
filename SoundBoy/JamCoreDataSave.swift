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
    let json = data as! JSONDictionary
    
    let context = coreDataStore.viewContext
    let jamToSave = Jam(context: context)
//    jamToSave.id = id
//    jamToSave.pin = pin
//    jamToSave.startTime = startTime
//    jamToSave.endTime = endTime
    jamToSave.isCurrent = true
    context.perform {
      do {
        try context.save()
        
      }catch {
        response(Result.failed(message: "Unable to save jam", error: error))
      }
    }
  }
  
}
