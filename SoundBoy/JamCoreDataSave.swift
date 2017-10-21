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
    let jamRes = try! decorder.decode(JamResponse.self, from: data)
    let context = coreDataStore.viewContext
    let jamToSave = Jam(context: context)
    jamToSave.id = jamRes.jam.id
    jamToSave.pin = jamRes.jam.pin
    jamToSave.startTime = jamRes.jam.startTime
    jamToSave.endTime = jamRes.jam.endTime
    jamToSave.isCurrent = true
    context.perform {
      do {
        try context.save()
        response(Result.success(data: jamToSave))
      }catch {
        response(Result.failed(message: "Unable to save jam", error: error))
      }
    }
  }
  
}
